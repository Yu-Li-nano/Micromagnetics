OS environment: Ubuntu16.04.3

1. Open the terminal
```
sudo apt-get install git golang-go gcc gnuplot
```

2. Download the Mumax3 package
    I used mumax3.10beta_CUDA9.0 from issue #175 in Mumax3 github
3. Unzip .tar.gz file, and extract into certan path (eg. $~/mumax)
4. Add environment variable
(pre-installation of vim is required!)
```
sudo vim ~/.bashrc
export PATH=”ThePathOfMumax3:$PATH”
```
5. Install CUDA (eg. CUDA 9.0) from https://developer.nvidia.com/cuda-90-download-archive

    5.1. Select Linux – x86_64 – Ubuntu – 16.04 – deb (network)
    
    5.2. cd to “.deb” path and open terminal
```
sudo dpkg -i cuda-repo-ubuntu1604_9.0.176-1_amd64.deb
sudo apt-key adv --fetch-keys http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/7fa2af80.pub
sudo apt-get update
sudo apt-get install cuda-libraries-9-0
```
6.	Install NVIDIA Driver
go to system settings (top-right corner of the screen) – Software & updates – Additional Drivers – Using NVIDIA binary driver (choose latest one).
Then the graphic driver conflict won’t happen. (If not, you cannot get access into the X server after NVIDIA driver is installed and reboot.)
7.	Reboot computer and enjoy your Mumax3 exploration:)

*Notice the requirement in Mumax3 official website, e.g., for Mumax 3.10beta2, you need 'CUDA 10' and' NVIDIA driver 410.48' for linux version.