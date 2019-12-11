import React from 'react'
import './card.styles.css'


export const Card = props => {

    const champ = <img alt="champion" height="30%" width="30%" style={{ alignSelf: 'center' }} src={`./champs/${props.champion.name}.png`}/>;
    const cost = <img alt="origin" height="10%" width="10%" src={`./origin/icon-gold.svg`}/> ;
    var champ_class = <img alt="class" height="10%" width="10%" src={`./origin/${props.champion.class}.png`}/>
    var alt_origin = <img alt="class" height="10%" width="10%" src={`./origin/${props.champion.alt_origin}.png`}/>
    var origin = <img alt="class" height="10%" width="10%" src={`./origin/${props.champion.origin}.png`}/>
    var alt_class = <img alt="class" height="10%" width="10%" src={`./origin/${props.champion.alt_class}.png`}/>
    var attributes = <p> {origin} {champ_class} {cost} {props.champion.cost} </p>
    if (props.champion.name == 'Kindred') {
        var attributes = <p> {origin} {alt_origin} {champ_class} {cost} {props.champion.cost} </p>
    }
    if (props.champion.name == 'Volibear') {
        var attributes = <p> {origin} {alt_origin} {champ_class} {cost} {props.champion.cost} </p>
    }
    if (props.champion.name == 'MasterYi') {
        var attributes = <p> {origin} {champ_class} {alt_class} {cost} {props.champion.cost} </p>
    }
    if (props.champion.name == 'Zed') {
        var attributes = <p> {origin} {champ_class} {alt_class} {cost} {props.champion.cost} </p>
    }
    return(
    <div className='card-container'> 
        {champ}
        <h4> {props.champion.name} </h4> 
        {attributes}
    </div>
    )
};