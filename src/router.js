import React, { Component } from 'react';
import { createBottomTabNavigator, createStackNavigator, createAppContainer } from 'react-navigation';

import Home from './containers/Home'
import Circle from './containers/Circle'

const Tab = createBottomTabNavigator({
    Index: { screen: Home},
    Circle: { screen: Circle},
})

// const Router = createStackNavigator({
//     Tab:{screen: Tab},
// })


export default createAppContainer(Tab);
