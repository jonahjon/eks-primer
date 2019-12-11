import React, { Component } from 'react';
import champsJSON from './set2.json'
import { CardList } from './components/card-list/card-list'
import { Search } from './components/search/search'
import './App.css';

class App extends Component {
  constructor() {
    super();
    this.state = {
      champions: champsJSON,
      searchfield: ''
    }
  }

  handleChange = (e) => {
    this.setState({searchfield: e.target.value});
  };

  // componentDidMount() {
  //   fetch('https://raw.githubusercontent.com/MaxJW/tfthelper/master/data/champions.json')
  //   .then(response => response.json())
  //   .then(users => this.setState({ champions: users }));
  // }

  render() {
    const { champions, searchfield } = this.state;

    const filteredChampions = champions.filter(champion =>
      champion.name.toLowerCase().includes(searchfield.toLowerCase())
    )
    // const costChampions = champions.filter(champion =>
    //   champion.cost.includes(searchfield)
    // )
    return (
      <div className="App">
         <h1>TFT Directory</h1>
         <Search
            type='search'
            placeholder='Champion'
            handleChange={this.handleChange}
         />
        <CardList champions={filteredChampions}/>
      </div>
    );
  }

}
export default App;
