// Authors: Jacob Wilson

//declare text and Button
const textBox = document.getElementById("textbox");
var button = document.getElementById('myBtn');// Read Data
//will get complete collection with this method;
// Selectors
const elementsArray = [];
elementsArray.push(document.getElementById("textBox"));

//tr rows
//td columns
db.collection("messages").onSnapshot(function (snapshot) {
  snapshot.docChanges().forEach(function (change) {
    if (change.type === "added") {
      const data = change.doc.data();
      //find latest updates
      const nodeTr = document.createElement("tr");
      const nodemsg = document.createElement("td");
     
      //add to html --> KEEP IN ORDER WHEN USED ANYWHERE IN CRUD
      nodemsg.innerHTML += data.message;
      
    

      //add new nodes q
      nodeTr.appendChild(nodemsg);
      
      //Update Page
      nodeTr.id = `${change.doc.id}`;
      table.appendChild(nodeTr);

      //allows to shift when mouse is over
      document.getElementById(nodeTr.id).onmouseover = function(){
        this.style.backgroundColor = "rgba(0, 217, 255, 0.979)";
        this.style.transform = "translate(33px,0)";
      }
      document.getElementById(nodeTr.id).onmouseout = function(){
        this.style.backgroundColor = "white";
        this.style.transform = "translate(0px,0)";
      }

    }else if (change.type === "modified") {
      console.log("Modified ", change.doc.data());
    } else if (change.type === "removed") {
      const elem = document.getElementById(change.doc.id);
      table.removeChild(elem);
    }
  });
});


// Email will be handled below. Sends notification of success of schedule and message being sent. 
// Actual sending of Messages are handled by the other Mercury messanger.
