import React, { Component } from 'react';
import { Provider } from 'mobx-react';
import RNAlibcSdk from './component/Alibaichuan'
import stores from './stores'
import Stack from './router'

console.disableYellowBox = true;


export default class ShoppingGuide extends Component{

    componentDidMount = async () => {
        let initAlibc = await RNAlibcSdk.init();
        console.log('========================')
        console.log(initAlibc);
        console.log('========================')
      };

    render(){
        return (
            <Provider {...stores}>
                <Stack/>
            </Provider>
        )
    }
}
