const firebase = require('firebase')
const config = {
    apiKey: "AIzaSyBsaKnEkZ9MfJzsh_6ajoypvccFFUvV5-I",
    projectId: "qard-25427",
    authDomain: "qard-25427.firebaseapp.com",
    databaseURL: "https://qard-25427.firebaseio.com",
    storageBucket: "qard-25427.appspot.com"
};
var database;

module.exports = async (userId = 'default', cardId = 'testCardd', cardData = "") => {
    // initialize db
    if (!firebase.apps.length) {
        firebase.initializeApp(config);
    }
    database = firebase.firestore();

    return createCard(userId, cardId, cardData);
};

var createCard = function(userId, cardId, cardData) {
    var docRef = database.collection("users").doc(userId);
    var cardDataString = cardData.replace(/\\/g, '');
    var jsonCardData = JSON.parse(cardDataString);
    jsonCardData["cardId"] = cardId;
    return docRef.get()
      .then(function(docData) {
          if (docData.exists) {
              var cards = docData.data()["cards"];
              var existingCard = cards.find(function(card) {
                  return card["cardId"] == cardId;
              });
              if (existingCard) {
                  return "Card with name " + cardId + " already exists"
              }

              cards.push(jsonCardData);
              return docRef.update({
                  cards: cards
              }).then(function() {
                  return "added";
              });
          } else {
              return userId + " doesn't exist";
          }
      });
};
