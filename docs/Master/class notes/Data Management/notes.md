# Data Management for Large scale data[^1]

## MapReduce and Hadoop[^2]

## MapReduce

- Publication at Google
- Main idea:
    - Data represented as key-value pairs
    - 2 op: Map and Reduce
    - Distributed file system
- Algorithm
    - The Map operation
        - Transform op
        - A function is applied to each element of the set
    - The Reduce operation
        - Aggregation op
        - Apply to all elements with the same key
- Advantage
    - Simple to program
        - Provide a distributed computing execution framework
            - Simplifies parallelization: \
                - Defines a programming model
                - Handles distribution of the data and the computation.
            - Fault tolerant 

                Detect failures and automatically takes corrective actions

            - **Code once, benefit all**

        - Limits the operations that a user can run on data
            - Functional programming
            - Allows expressing several algorithms
                - Not all algorithm can be expressed this way
    - Scalability
        - Data parallelism
            - Running the same task on different data pieces in parallel
            - Opposed to *Task parallelism* that runs different tasks in parallel
        - Move the computation instead of the data
            - The distributed file system is central to the framework
                - GFS
                - Heavy use of partitioning
            - The tasks are executed where the data are stored
                - Moving data is costly
    - Automatic error handling
        - Motivations
            - Failures are the norm
                - Job can be preempted at anytime
                - MapReduce jobs have low priority and high chances of preempted
            - Dealing with strangglers
        - Mechanisms
            - Data are replicated in the distributed file system
            - Results of computation are written to disk
            - Failed tasks are re-executed on other nodes
            - Tasks can be replicated several times in parallel to deal with stranglers

- Examples: Words count
    - Input A set of lines including words
        - Pairs < Line number, line content >
        - The initial key is ignored
    - Output: set of pairs: < words, nb of orcurrence >
```r
map(key, value):
    foreach word in value.split()
        emit(word, 1)

reduce(key,values):
    result = 0
    for value in values:
        result += values
    emit(key,result)
```
- Examples: Web index

```
map(key, value):
    foreach word in value.parse():
        emit(word, key)

reduce(key, values):
    list = []
    for value in values:
        list.add(value)
    emit(key,list)
```

- About Batch vs Stream Processing
    - Batch processing:
        - Take a large amount of data and process it at once.
        - Assume that we have all data available at the time of execution. The amount of data is bounded
    - Stream processing:
        - Process data shortly after they have been received
        - (Near) Realtime system
        - Data not available at start of execution - the amount of data is unbounded

## Hadoop
1. History
    - Opensource implementation of MapReduce framework
        - Implemented by Yahoo
        - Inspired from the publications of Google
        - Released in 2006
    - Evolution
        - Start as a File system and a MapReduce framework
        - Evoluted into a full ecodsystem
        - Used by many company
            - Facebook Big Data Stack, etc
1. Hadoop Ecosystem
    - Main blocks
        - HDFS
        - Yarn
        - MapReduce
    - Other blocks

    - About Yarm: 
        - A resource management framework
            - Dynamically allocates the resources of a cluster to jobs
            - Allows multiple engines to run in parallel on the cluster
                - Not all jobs are MapReduce
                - Increase resource usage
            - Hierarchical infrastructure for scalability
                > Federation
        - Components
            - *ResourceManager*
            - *ApplicationMaster*
            - *NodeManager*
        - Architecture
1. HDFS
- Acronym: Hadoop Distributed File System
- Purpose: Sore and provide access to tlarge datasets in a share-nothing infrastructure
- Challenges:
    - Scalability
    - Fault tolerance
- Main Principles
    - Main assumptions:
        - Large dataset
            - Large bandwidth
            - Store large amount of files
        - Batch processing
            - not POSIX
            - Assumes sequential read and writes
                - Write once, read many
                - Write ops: Append and Truncate
                - Stream reading
        - Optimized for high throughput (high latency)
    

[^1]: [slide Intro](https://tropars.github.io/downloads/lectures/LSDM/LSDM-1-introduction.pdf)
[^2]: [slide Hadoop](https://tropars.github.io/downloads/lectures/LSDM/LSDM-2-mapreduce-hadoop.pdf)