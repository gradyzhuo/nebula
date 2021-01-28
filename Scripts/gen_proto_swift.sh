#!/bin/zsh

function make_proto_swift(){
  proto_path=$1
  pushd $(dirname $proto_path)
  proto_dir=$(pwd)
  popd
  
  target_dir=$2
  if [[ -z $target_dir ]]; then
    target_dir=$proto_dir
  fi
  protoc $proto_path \
                --proto_path=$proto_dir \
                --plugin='/usr/local/bin/protoc-gen-swift' \
                --swift_opt=Visibility=Public \
                --swift_out=$target_dir

  protoc $proto_path \
                --proto_path=$proto_dir \
                --plugin='/usr/local/bin/protoc-gen-grpc-swift' \
                --grpc-swift_opt=Visibility=Public \
                --grpc-swift_out=$target_dir
}


#make_proto_swift '/Users/gradyzhuo/Library/Mobile Documents/com~apple~CloudDocs/開發測試/Nebula/Protos/bridge.proto' '/Users/gradyzhuo/Library/Mobile Documents/com~apple~CloudDocs/開發測試/Nebula/Sources/Nebula/Dispatcher/GRPC/Model'

make_proto_swift '/Users/gradyzhuo/Library/Mobile Documents/com~apple~CloudDocs/Work/awoo/workspace/swift/Nebula/Protos/matter.proto' '/Users/gradyzhuo/Library/Mobile Documents/com~apple~CloudDocs/Work/awoo/workspace/swift/Nebula/Sources/Nebula/Model'
