import React from 'react'
import './card-list.styles.css'
import { Card } from '../card/card'

export const CardList = props => {
    return <div className='card-list'>
        {props.champions.map(champion => (
            <Card key={champion.name} champion={champion}/>
        ))}
        {/* {props.champions.map(champion => (
            <Card key={champion.cost} champion={champion}/>
        ))} */}
    </div>
};