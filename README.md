# Access Global Pool GPU resources via SSH

The following example submits a sleep job requesting GPU jobs
and transfers a singularity wrapper script to setup tensorflow
interactively (after the user access the node via SSH).

Current example uses GPUs coming from UCSD and Nebraska.

The job will execute for about 8 hours by default.
To change the desired walltime for the resource to be available,
edit the following parameter request\_gpus.jdl:

```
# Walltime for job in minutes
# Default ~8 hours
+MaxWallTimeMins = 500
```

To get SSH access to the job, follow the instructions below:

```
# 1. Submit request
$ condor_submit request_gpus.jdl
Submitting job(s).
1 job(s) submitted to cluster 4967783.

# 2. Wait for it, until it starts running (R state), it can take a few minutes
#    depending on the availability of resources.
#     Monitor via condor_q
$ condor_q 4967783.0

-- Schedd: login.uscms.org : <192.170.227.118:9618?... @ 11/16/18 08:47:57
 ID         OWNER            SUBMITTED     RUN_TIME ST PRI SIZE CMD
4967783.0   khurtado       11/16 08:46   0+00:00:09 R  0    0.0 connect_wrapper.sh sleep.sh

# 3. Now, access to it via ssh:
$ condor_ssh_to_job 4969789.0
Welcome to slot1_1@glidein_36930_830805504@cgpu-1.t2.ucsd.edu!
Your condor job is running with pid(s) 29916.
[0849] cuser6@cgpu-1 /data1/condor_local/execute/dir_36926/glide_hYQHlu/execute/dir_29832$

# 4. Now, enter the container shell
./singularity_wrapper.sh bash

# 5. Start using tensorflow!
```

A quick example using Tensorflow with the GPU resource:

````
# 1. Enter singularity container shell
[0851] cuser6@cgpu-1 /data1/condor_local/execute/dir_36926/glide_hYQHlu/execute/dir_29832$ ./singularity_wrapper.sh bash
cuser6@cgpu-1:~$ cat /etc/issue
Ubuntu 16.04.5 LTS \n \l

# 2. Download an example from stash
cuser6@cgpu-1:~$ wget http://stash.osgconnect.net/~khurtado/tensorflow/tf_matmul.py
--2018-11-16 16:53:52--  http://stash.osgconnect.net/~khurtado/tensorflow/tf_matmul.py
Resolving stash.osgconnect.net (stash.osgconnect.net)... 192.170.227.197
Connecting to stash.osgconnect.net (stash.osgconnect.net)|192.170.227.197|:80... connected.
HTTP request sent, awaiting response... 200 OK
Length: 578 [application/octet-stream]
Saving to: 'tf_matmul.py'

tf_matmul.py                              100%[=====================================================================================>]     578  --.-KB/s    in 0s

2018-11-16 16:53:52 (60.5 MB/s) - 'tf_matmul.py' saved [578/578]

# 3. Execute example
cuser6@cgpu-1:~$ python3 tf_matmul.py
2018-11-16 16:56:37.914379: I tensorflow/core/platform/cpu_feature_guard.cc:141] Your CPU supports instructions that this TensorFlow binary was not compiled to use: AVX2 FMA
2018-11-16 16:56:41.677599: I tensorflow/core/common_runtime/gpu/gpu_device.cc:1405] Found device 0 with properties:
name: GeForce GTX 1080 Ti major: 6 minor: 1 memoryClockRate(GHz): 1.582
pciBusID: 0000:85:00.0
totalMemory: 10.92GiB freeMemory: 10.76GiB
2018-11-16 16:56:41.678089: I tensorflow/core/common_runtime/gpu/gpu_device.cc:1484] Adding visible gpu devices: 0
2018-11-16 16:57:35.059743: I tensorflow/core/common_runtime/gpu/gpu_device.cc:965] Device interconnect StreamExecutor with strength 1 edge matrix:
2018-11-16 16:57:35.062858: I tensorflow/core/common_runtime/gpu/gpu_device.cc:971]      0
2018-11-16 16:57:35.062898: I tensorflow/core/common_runtime/gpu/gpu_device.cc:984] 0:   N
2018-11-16 16:57:35.063932: I tensorflow/core/common_runtime/gpu/gpu_device.cc:1097] Created TensorFlow device (/job:localhost/replica:0/task:0/device:GPU:0 with 10407 MB memory) -> physical GPU (device: 0, name: GeForce GTX 1080 Ti, pci bus id: 0000:85:00.0, compute capability: 6.1)
Device mapping:
/job:localhost/replica:0/task:0/device:GPU:0 -> device: 0, name: GeForce GTX 1080 Ti, pci bus id: 0000:85:00.0, compute capability: 6.1
2018-11-16 16:57:35.291222: I tensorflow/core/common_runtime/direct_session.cc:288] Device mapping:
/job:localhost/replica:0/task:0/device:GPU:0 -> device: 0, name: GeForce GTX 1080 Ti, pci bus id: 0000:85:00.0, compute capability: 6.1

2018-11-16 16:57:35.298476: I tensorflow/core/common_runtime/gpu/gpu_device.cc:1484] Adding visible gpu devices: 0
2018-11-16 16:57:35.298533: I tensorflow/core/common_runtime/gpu/gpu_device.cc:965] Device interconnect StreamExecutor with strength 1 edge matrix:
2018-11-16 16:57:35.298552: I tensorflow/core/common_runtime/gpu/gpu_device.cc:971]      0
2018-11-16 16:57:35.298571: I tensorflow/core/common_runtime/gpu/gpu_device.cc:984] 0:   N
2018-11-16 16:57:35.298746: I tensorflow/core/common_runtime/gpu/gpu_device.cc:1097] Created TensorFlow device (/job:localhost/replica:0/task:0/device:GPU:0 with 10407 MB memory) -> physical GPU (device: 0, name: GeForce GTX 1080 Ti, pci bus id: 0000:85:00.0, compute capability: 6.1)
Device mapping:
/job:localhost/replica:0/task:0/device:GPU:0 -> device: 0, name: GeForce GTX 1080 Ti, pci bus id: 0000:85:00.0, compute capability: 6.1
2018-11-16 16:57:35.298929: I tensorflow/core/common_runtime/direct_session.cc:288] Device mapping:
/job:localhost/replica:0/task:0/device:GPU:0 -> device: 0, name: GeForce GTX 1080 Ti, pci bus id: 0000:85:00.0, compute capability: 6.1

MatrixInverse: (MatrixInverse): /job:localhost/replica:0/task:0/device:GPU:0
2018-11-16 16:57:35.301525: I tensorflow/core/common_runtime/placer.cc:935] MatrixInverse: (MatrixInverse)/job:localhost/replica:0/task:0/device:GPU:0
MatMul: (MatMul): /job:localhost/replica:0/task:0/device:GPU:0
2018-11-16 16:57:35.301561: I tensorflow/core/common_runtime/placer.cc:935] MatMul: (MatMul)/job:localhost/replica:0/task:0/device:GPU:0
Const: (Const): /job:localhost/replica:0/task:0/device:GPU:0
2018-11-16 16:57:35.301604: I tensorflow/core/common_runtime/placer.cc:935] Const: (Const)/job:localhost/replica:0/task:0/device:GPU:0
result of matrix multiplication
===============================
[[ 1.0000000e+00  0.0000000e+00]
 [-4.7683716e-07  1.0000002e+00]]
===============================
cus`er6@cgpu-1:~$
```

