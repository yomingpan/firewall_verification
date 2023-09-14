#!/bin/bash

# 預設值
verbose=0
success_count=0
fail_count=0

while [[ $# -gt 0 ]]
do
    key="$1"

    case $key in
        -f|--file)
        file="$2"
        shift # 移動到下一個參數
        shift # 移動到下一個參數
        ;;
        -v)
        verbose=1
        shift # 移動到下一個參數
        ;;
        -vv)
        verbose=2
        shift # 移動到下一個參數
        ;;
        *)
        echo "未知的選項: $1"
        exit 1
        ;;
    esac
done

# 檢查是否指定了 `-f` 選項
if [ -z "$file" ]; then
    echo "請使用 -f 選項指定檔案路徑，例如：./check_ports.sh -f firewall.txt"
    exit 1
fi

# 讀取檔案內容並處理每一行
while IFS= read -r line
do
    # 分割每一行的欄位
    IFS=':' read -r -a fields <<< "$line"

    # 取得協議、目的地主機和端口列表
    protocol="${fields[0]}"
    host="${fields[1]}"
    ports="${fields[2]}"

    # 分割端口列表
    IFS=',' read -r -a port_list <<< "$ports"

    # 測試每個端口
    for port in "${port_list[@]}"
    do
        if [ "$protocol" == "tcp" ]; then
            # 測試TCP連接
            if nc -zv -w 2 "$host" "$port" >/dev/null 2>&1; then
                if [ $verbose -gt 1 ]; then
                    echo "succeeded -> [tcp/$port] $host:$port"
                fi
                success_count=$((success_count + 1))
            else
                if [ $verbose -ge 1 ]; then
                    echo " failed -> [tcp/$port] $host:$port"
                fi
                fail_count=$((fail_count + 1))
            fi
        elif [ "$protocol" == "udp" ]; then
            # 測試UDP連接
            if nc -uzv -w 2 "$host" "$port" >/dev/null 2>&1; then
                if [ $verbose -gt 1 ]; then
                    echo "succeeded -> [udp/$port] $host:$port"
                fi
                success_count=$((success_count + 1))
            else
                if [ $verbose -ge 1 ]; then
                    echo " failed -> [udp/$port] $host:$port"
                fi
                fail_count=$((fail_count + 1))
            fi
        else
            echo "無效的協議: $protocol"
        fi
    done

done < "$file"

# 總結成功和失敗的數量
echo "總結: 成功 $success_count 個，失敗 $fail_count 個"
