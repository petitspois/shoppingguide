import React, { Component } from 'react'
import { TouchableOpacity, Text, View, SafeAreaView } from 'react-native';
import RNAlibcSdk from '../component/Alibaichuan'


export default class Home extends Component {
    render() {
        return (
            <SafeAreaView>
                <View>
                    <Text>首页</Text>
                    <TouchableOpacity onPress={() => {
                        RNAlibcSdk.show({
                            type: 'url',
                            payload: 'https://item.taobao.com/item.htm?spm=a219t.7900221/10.1998910419.d5d3d3cdd.b2dc75a5zH070k&id=560056191214'
                        },
                        (err, info) => {
                            if (!err)
                            console.log(info)
                            else
                            console.log(err)
                        }
                        )
                    }}>
                        <Text>打开淘宝链接</Text>
                    </TouchableOpacity>
                </View>
            </SafeAreaView>
        )
    }
}