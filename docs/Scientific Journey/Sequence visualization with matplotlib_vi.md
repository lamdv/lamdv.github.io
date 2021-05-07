# Hiển thị dữ liệu chuỗi với matplotlib

##### *The dirty way* [^1]


Có lẽ đã có rất nhiều package Python cho phép hiển thị dữ liệu Multiple Sequence Alignment (MSA). Tuy vậy, thời gian của kỹ sư phần mềm và nhà nghiên cứu tin sinh học có lẽ nên dành để suy nghĩ về thuật toán và phát triển phần mềm riêng hơn là ngồi học thêm một vài package mới. Đôi khi khác thì các package chưa chắc đã hiển thị đúng metrics và định dạng mà ta mong muốn. Trong notebook này mình sẽ thử hiển thị một dataset MSA ngắn (75 residues) và một biểu đồ cột cho thấy tính bảo toàn của từng residue sử dụng matplotlib. Phép tính độ bảo toàn này không đúng lắm, nhưng điều đó không quá quan trọng. Cuối cùng chúng ta cũng hiển thị một chuỗi đồng thuận, chuỗi này là từng amino acid có tỉ lệ cao nhất ở mỗi residue - một lần nữa, điều này có thể không chính xác về mặt sinh học, nhưng các bạn có thể thay đổi để cho phù hợp hơn với dữ liệu và thống kê của riêng mình.


## Ý tưởng

Ý tưởng đằng sau biểu đồ này là dựa vào biểu đồ thống kê chính, chúng ta lần lượt đặt từng residue vào vị trí của nó dưới các cột biểu đồ. Bởi vì matplotlib xác định vị trí các đối tượng trong biểu đồ của mình qua "data space" hay các mốc vị trí dựa trên dữ liệu, chúng ta có thể "hack" nó để gióng hàng các residue của mình. Đơn giản vầy thui.

## Yêu cầu
1. Thư viện
   
Ta cần các thư viện sau: matplotlib (duh), BioPython và NumPy. BioPython dùng để quản lý, đọc và ghi các MSA, dù ta cũng có thể tự viết parser và đọc file FASTA trực tiếp - nhưng mà lười :D. NumPy dùng để tính toán và tương tác với matplotlib, ngoài ra thời này ai mà chẳng dùng numpy khi viết tutorial trên mạng cơ chứ...


```python
import numpy as np, Bio, matplotlib.pyplot as plot
from matplotlib.ticker import FormatStrFormatter
from Bio import SeqIO

%matplotlib inline
```

1. Để vẽ một cách chính xác, trước hết ta cần định nghĩa vài thứ. Trước tiên, chúng ta cần một họ font monospace để đảm bảo các residue sẽ được thẳng hàng. Monospace font có khoảng cách bằng nhau bất kể ký tự - chữ A và chữ I đều tốn diện tích như nhau. Dễ hiểu tại sao chúng ta cần font này phải không.

```python
font = {'family': 'monospace',
        'color':  'darkred',
        'weight': 'normal',
        'size': 16,
        }
```
Tiếp theo chúng ta cần một cái bảng màu. Có 20 amino acid, và cần thêm 1 màu để hiển thị gap. Bảng màu mình sử dụng ở đây cũng là bảng màu được RasMol sử dụng (cái phần mềm này xưa như trái đất rồi holy f)


```python
palette = [
    '#C8C8C8', '#145AFF', '#00DCDC', '#E60A0A', '#E6E600',
    '#00DCDC', '#E60A0A', '#EBEBEB', '#8282D2', '#0F820F', 
    '#0F820F', '#145AFF', '#E6E600', '#3232AA', '#DC9682', 
    '#FA9600', '#FA9600', '#B45AB4', '#3232AA', '#0F820F', 
    '#FFFFFF']
```

Cuối cùng ta có một string chứa tất cả các amino acid có thể nhận, và khoảng trống

```python
aa = 'ARNDCQEGHILKMFPSTWYV-'
```

## Đọc đọc đọc...

Việc đầu tiên, đương nhiên là đọc cả chuỗi MSA và tính toán một số thông số cơ bản: Chiều dài chuỗi L và số chuỗi N.


```python
fasta_file = 'src/Inputs/example/1atzA.fas'
msa = list(SeqIO.parse(fasta_file,'fasta'))
L = len(msa[0].seq)
N = len(msa)
```

Tính toán tần suất từng amino acid ở mỗi residue, và nhân tiện tính luôn chuỗi đồng thuận.

```python
freq = np.zeros([L,21])
concensus = np.zeros(L)
for i in range(0,N):
    for j in range(0,L):
        j_aa = aa.find(msa[i].seq[j])
        freq[j,j_aa] = freq[j,j_aa] + 1
for i in range(0, L):
    concensus[i] = freq[i].argmax()
```

Chắc đoạn này dễ ha. 

Để tính toán độ bảo toàn, chúng ta dùng công thức như sau:

$$
C_i = \sqrt{\sum_{j}^{j=21}{(\frac{f_j}{N} - 0.05)^2}}
$$

với $C_i$ là độ bảo toàn của residue thứ $i$.

Tại sao lại là 0.05? Bởi vì nó là $1/20$, và ở thì có 20 amino acid. Khoảng trống không tính...
*(tất nhiên là có 21 giá trị có thể nhận được nhưng mà cái note này đủ bậy rồi lmao)*


```python
conservation = np.sqrt(np.sum((np.square(freq/N - 0.05)),axis=1))
```

## OK đến đoạn vui

Bởi vì không có cách nào có sẵn để vẽ cả mớ chuỗi này vào đồ thị, chỗ code dưới này nhìn sẽ khá rối rắm. Đồng thời nó cũng chưa chắc là cách ngon nhất để làm (chắc không phải đâu)... nhưng nó là một cách

<!-- *Notes: I put *````figure````* in places where I want to draw the figure **for demonstration purpose**. You may want to remove them when you recombine the code boxes in your notebook, otherwise it will draw multiple graph. On itself.* -->

Trước tiên, tất nhiên ta tạo một đồ thị và các trục tương ứng. Cái đồ thị này được thiết lập khá rộng, vì cái chuỗi nhét vào nó dàii *wink wink*.


```python
figure = plot.figure(figsize=(20,2))
axes = plot.axes([0,0,1,1]);
plot.close()
```

OK giờ đến lúc vẽ cái đồ thị về độ bảo toàn. nó đơn giản chỉ là một cái bar graph cho thấy độ bảo toàn ở từng residue.

Reminder: để gọi bargraph: ````axes.bar(range,data,**args)````. Trong trường hợp này chúng ta cần các parameters ````align='edge', linewidth=0```` để gióng hàng các amino acid. ````align='edge'```` làm cho các cột gióng hàng ở cạnh trái, và ````linewidth=0```` làm cho khoảng cách các cột khít hơn.


```python
axes.bar(range(0,L),conservation, align='edge', linewidth = 0, color = 'red')
axes.set_ylabel('Conservation')
```




    
![svg](Sequence%20visualization%20with%20matplotlib_files/Sequence%20visualization%20with%20matplotlib_21_0.svg)
    



Giờ đến lúc vẽ các chuỗi. Chúng ta lấy ra 5 chuỗi ngẫu nhiên từ MSA, đơn giản vì với 1000 chuỗi thì data của mình quá rộng để có thể vẽ tất cả. Đồng thời chúng ta tính toán khoảng cách giữa các chuỗi, cũng như khoảng cách từ đáy đồ thị đến chuỗi đầu tiên.

Khoảng cách giữa các chuỗi được tính bằng cận của trục y chia 6. Tại sao? Vì chia 6 nó khớp hàng 😅, không có giải thích nào hay hơn cả ...

```python
spacing_scale = axes.get_ylim()[1]/6
spacing = spacing_scale*2

seq_display = np.sort(np.random.randint(0,N,[5]))
```

Ok, giờ thì làm sao mà vẽ?

Với mỗi chuỗi, trước tiên ta tính toán khoảng cách đến gốc tọa độ $(0, 0)$. Vị trí trục x của từng residue được tính toán đơn giản là vị trí của chính nó trong chuỗi. Khá gọn. Tiêu đề của từng chuỗi được vẽ dịch về bên trái bằng cách lấy giá trị x âm, và trong trường hợp này ta lấy là -5.

````axes.text()```` được gọi để vẽ từng residue. Với mỗi residue chúng ta có một cái bbox vẽ đè lên. Các bbox này có ````alpha=0.5```` để nó  trong suốt, và màu như trong palette màu đã định nghĩa ở trên.

À mà nhớ dùng ````fontdict=font```` để xài cái font family nãy nhé.


```python
for j in seq_display:
    posit = -float(np.where(seq_display == j)[0]) * spacing_scale - spacing
    axes.text(-5,posit, "Seq "+(str(j+1)))
    for i in range(0, L):
        axes.text(float(i),posit, msa[j].seq[i],
            bbox=dict(facecolor=palette[aa.find(msa[j].seq[i])], 
            alpha=0.5),fontdict=font)
```




    
![svg](Sequence%20visualization%20with%20matplotlib_files/Sequence%20visualization%20with%20matplotlib_25_0.svg)
    



Cuối cùng, chúng ta thêm chuỗi đồng thuận:

```python
posit = posit - spacing
axes.text(-5,posit, "Concensus")
for i in range(0, L):
    axes.text(float(i),posit, 'ARNDCQEGHILKMFPSTWYV-'[int(concensus[i])] ,
                bbox=dict(facecolor=palette[int(concensus[i])], 
                alpha=0.5),fontdict=font)
```




    
![svg](Sequence%20visualization%20with%20matplotlib_files/Sequence%20visualization%20with%20matplotlib_27_0.svg)
    



Et voila! Đây là một cách nhanh (và bẩn) để hiển thị dataset. Mình hi vọng nó đủ đơn giản để các bạn có thể tự biển đổi nó cho từng loại dữ liệu riêng (Genomics, transcriptomics...), và cũng như dùng các loại đồ thị khác làm nền tảng. Tuy nhiên, phương pháp này có lẽ không phải là cách tốt nhất để hiển thị các chuỗi dài hơn - bạn phải tự tìm đường phù hợp nhất với dữ liệu của mình. Nhưng đó là điều hay ho khi làm Bioinfomatics!!! Và giờ thì bạn có toàn quyền kiểm soát trên quá trình rồi.


[^1]: Notebook Jupyter gốc (tiếng Anh) thì ở [đây](https://github.com/lamdv/lamdv.github.io/blob/source/docs/Sequence%20visualization%20with%20matplotlib.ipynb)