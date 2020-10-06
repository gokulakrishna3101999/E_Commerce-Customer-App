import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shop/products_details.dart';

Future getData() async
  {
    var firestore = Firestore.instance;
    QuerySnapshot data = await firestore.collection("products").getDocuments();
    return data.documents;
  }

class Products extends StatefulWidget {
  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  @override
  Widget build(BuildContext context) {
    
    return Container(
      child: FutureBuilder
      (
        future: getData(),
        builder: (context,AsyncSnapshot snapshot)
      {
         if(snapshot.connectionState == ConnectionState.waiting)
         return Center
         (
           child: Text("Loading Products...",style: new TextStyle(color:Colors.pink,fontWeight:FontWeight.bold),),
         );
         else
         {
           return GridView.builder
          (
          itemCount: snapshot.data.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2) ,
          itemBuilder: (BuildContext context,int index)
          {
         return Padding(
          padding: const EdgeInsets.all(4.0),
          child: SingleProducts
          (
            productsName: snapshot.data[index].data['name'],
            productsOldPrice: snapshot.data[index].data['oldPrice'],
            productsPrice: snapshot.data[index].data['price'],
            productsPicture: snapshot.data[index].data['picture'],
            productID: snapshot.data[index].data['product id'],
          ),
          );
         },
        );
         }
       }),
      );
  }
}

class SingleProducts extends StatelessWidget {
  final productsName;
  final productsPicture;
  final productsOldPrice;
  final productsPrice;
  final productID;

  SingleProducts({this.productsName,this.productsPicture,this.productsOldPrice,this.productsPrice,this.productID});
  @override
  Widget build(BuildContext context) {
    return Card
    (
      child: Hero
      (
        tag: new Text("hero"),
        child: Material
        (
         child: InkWell
         (
           onTap: ()
           {
              Navigator.push(context,MaterialPageRoute(builder: (context) => ProductsDetails
              (
                productDetailName: productsName,
                productDetailPicture: productsPicture,
                productDetailPrice: productsPrice,
                productDetailOldPrice: productsOldPrice,
                productID: productID,
              )),);
           },
           child: GridTile
           (
             child: Container
             (
               height: 150.0,
               child: Image.network(productsPicture,fit: BoxFit.cover,)
             ),
             footer: Container
             (
               height: 20.0,
               color: Colors.white,
               child: new Row
               (
                 children: <Widget>
                 [
                   Expanded
                   (
                     child: Text(productsName,style: new TextStyle(fontWeight: FontWeight.bold,fontSize: 15.0),),
                   ),
                   new Text("\$$productsPrice",style: new TextStyle(color: Colors.pink,fontWeight: FontWeight.bold,))
                 ],
               )
             ),
           ),
         ),
        ),
      ),
    );
  }
}