#!/bin/sh
# install som lib
echo "initiate"
apt-get install gawk gcc-multilib bison g++-multilib wget -y
mkdir -p /glibc/source
cd /glibc/source
# get the source of glibc
Get_Glibc_Source(){
    if [ ! -d "/glibc/source/glibc-"$1 ]; then
        wget http://mirrors.ustc.edu.cn/gnu/libc/glibc-$1.tar.gz
        tar xf glibc-$1.tar.gz
    else
        echo "[*] /glibc/source/glibc-"$1" already exists..."
    fi
    
}
Install_Glibc_x64(){

    if [ -f "/glibc/x64/"$1"/lib/libc-"$1".so" ];then
        echo "x64 glibc "$1" already installed!"
        return
    fi

    mkdir -p /glibc/x64/$1
    cd glibc-$1
    mkdir build
    cd build
    ../configure --prefix=/glibc/x64/$1/ --disable-werror --enable-debug=yes
    make
    make install
    cd ../../
    rm -rf ./glibc-$1/build

}


Install_Glibc_x86(){

    if [ -f "/glibc/x86/"$1"/lib/libc-"$1".so" ];then
        echo "x86 glibc "$1" already installed!"
        return
    fi

    mkdir -p /glibc/x86/$1
    cd glibc-$1
    mkdir build
    cd build
    ../configure --prefix=/glibc/x86/$1/ --disable-werror --enable-debug=yes --host=i686-linux-gnu --build=i686-linux-gnu CC="gcc -m32" CXX="g++ -m32" 
    make
    make install
    cd ../../
    rm -rf ./glibc-$1/build

}

#delte the tar of glibc
Delete_Glibc_Tar() {
    rm glibc-$1.tar.gz
}

GLIBC_VERSION=$1
#echo ${GLIBC_VERSION}
if [ -n "$GLIBC_VERSION" ]; then
    Get_Glibc_Source $GLIBC_VERSION
    Install_Glibc_x64 $GLIBC_VERSION
    Install_Glibc_x86 $GLIBC_VERSION
    Delete_Glibc_Tar $GLIBC_VERSION
else
    for GLIBC_VERSION in '2.19' '2.23' '2.24' '2.25' '2.26' '2.27' '2.28' '2.29' 
    do
        Get_Glibc_Source $GLIBC_VERSION
        Install_Glibc_x64 $GLIBC_VERSION
        Install_Glibc_x86 $GLIBC_VERSION
        Delete_Glibc_Tar $GLIBC_VERSION
    done
fi
