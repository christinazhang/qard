const firebase = require('firebase')
const config = {
    apiKey: "AIzaSyBsaKnEkZ9MfJzsh_6ajoypvccFFUvV5-I",
    projectId: "qard-25427",
    authDomain: "qard-25427.firebaseapp.com",
    databaseURL: "https://qard-25427.firebaseio.com",
    storageBucket: "qard-25427.appspot.com"
};
var database;

module.exports = async (userId = 'defaultUser', cardId = 'defaultCard') => {
  // initialize db
  if (!firebase.apps.length) {
     firebase.initializeApp(config);
  }
  database = firebase.firestore();
  
  return deleteCard(userId, cardId);
  return `Hello ${name}, I built this API with Code on Standard Library!`;
};

var deleteCard = function(userId, cardId) {
  var docRef = database.collection("users").doc(userId);
  var getUserSnapshotPromise = docRef.get();
  
  return getUserSnapshotPromise.then(function(userSnapshot) {
    var userData = userSnapshot.data();
    var usersCards = userData["cards"];
    var indexOfCard = usersCards.findIndex(function(card) {
      return card["cardId"] == cardId;
    });
    usersCards.splice(indexOfCard, 1);
    console.log(usersCards);
    return docRef.update({
      "cards": usersCards
    }).then(function() {
      return "deleted";
    });
  });
}

