#!/bin/sh

mergedListFile="/jds/updateTeam/merged_list_file.sh"

function initupdateTeam() {
    git config --global user.name "$name"
    git config --global user.email "$email"
    echo -e "$SSH_PRIVATE_KEY" > /root/.ssh/id_rsa
    mkdir -p /updateTeam
    cd /updateTeam
    git init
    git remote add origin $updateTeam_URL
    git pull origin $updateTeam_BRANCH --rebase
    cp -f /jds/updateTeam/scripts_update.sh /usr/local/bin/upload
    chmod +x /usr/local/bin/upload
}

if [ 0"$updateTeam_URL" = "0" ]; then
    echo "没有配置远程仓库地址，跳过初始化。"
else
    if [ ! -d "/updateTeam/" ]; then
        echo "未检查到updateTeam仓库，初始化下载..."
        initupdateTeam
    fi
fi

## 使用本地脚本
if [ -d "/js/" ]; then
    cp -f /js/*.js /scripts
fi

## 京喜工厂自动开团
if [ "$jd_jxFactoryCreateTuan_ENABLE" = "Y" ]; then
    echo "# 京喜工厂自动开团" >> $mergedListFile
    echo "0 0-4/1 * * * cd /scripts && node jd_jxFactoryCreateTuan.js >> logs/jd_jxFactoryCreateTuan.log 2>&1 && upload >> logs/upload_jd_jxFactoryCreateTuan.log 2>&1" >> $mergedListFile
fi

## 更新抢京豆邀请码
if [ "$jd_updateBeanHome_ENABLE" = "Y" ]; then
    echo "# 更新抢京豆邀请码" >> $mergedListFile
    echo "0 0,2 * * * cd /scripts && node jd_updateBeanHome.js >> logs/jd_updateBeanHome.log 2>&1 && upload >> logs/upload_jd_updateBeanHome.log 2>&1" >> $mergedListFile
fi

## 京东签到领现金
if [ "$jd_updateCash_ENABLE" = "Y" ]; then
    echo "# 京东签到领现金" >> $mergedListFile
    echo "0 0 * * * cd /scripts && node jd_updateCash.js >> logs/jd_updateCash.log 2>&1 && upload >> logs/upload_jd_updateCash.log 2>&1" >> $mergedListFile
fi

## 京喜财富岛
if [ "$jd_updateCfd_ENABLE" = "Y" ]; then
    echo "# 京喜财富岛" >> $mergedListFile
    echo "1-3 0,7 * * * cd /scripts && node jd_updateCfd.js >> logs/jd_updateCfd.log 2>&1 && upload >> logs/upload_jd_updateCfd.log 2>&1" >> $mergedListFile
fi

## 全民开红包
if [ "$jd_updateRed_ENABLE" = "Y" ]; then
    echo "# 全民开红包" >> $mergedListFile
    echo "0 0,2 * * * cd /scripts && node jd_updateRed.js >> logs/jd_updateRed.log 2>&1 && upload >> logs/upload_jd_updateRed.log 2>&1" >> $mergedListFile
fi

## 更新东东小窝邀请码
if [ "$jd_updateSmallHome_ENABLE" = "Y" ]; then
    echo "# 更新东东小窝邀请码" >> $mergedListFile
    echo "0 0 * * * cd /scripts && node jd_updateSmallHome.js >> logs/jd_updateSmallHome.log 2>&1 && upload >> logs/upload_jd_updateSmallHome.log 2>&1" >> $mergedListFile
fi

## 赚京豆小程序
if [ "$jd_zzUpdate_ENABLE" = "Y" ]; then
    echo "# 赚京豆小程序" >> $mergedListFile
    echo "*/20 0-2/1 * * * cd /scripts && node jd_zzUpdate.js >> logs/jd_zzUpdate.log 2>&1 && upload >> logs/upload_jd_zzUpdate.log 2>&1" >> $mergedListFile
fi

## 更新京喜农场邀请码
if [ "$jd_updateNc_ENABLE" = "Y" ]; then
    echo "# 更新京喜农场邀请码" >> $mergedListFile
    echo "1-3 0 * * * cd /scripts && node jd_updateNc.js >> logs/jd_updateNc.log 2>&1 && upload >> logs/upload_jd_updateNc.log 2>&1" >> $mergedListFile
fi
