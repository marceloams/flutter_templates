import 'package:flutter/material.dart';
import 'package:virtual_shop/datas/product_data.dart';
import 'package:virtual_shop/screens/product_screen.dart';

class ProductTile extends StatelessWidget {

  final String type;  //type of the view
  final ProductData product; //objects tha will have info about the product

  ProductTile(this.type, this.product);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context)=>ProductScreen(product))
        );
      },
      child: Card(
        child: type == 'grid' ?
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch, //
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                AspectRatio( //to make an static size to the images
                  aspectRatio: 0.8,
                  child: Image.network( //image
                    product.images[0],
                    fit: BoxFit.cover
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        Text( //title
                            product.title,
                            style: TextStyle( fontWeight: FontWeight.w500)
                        ),
                        Text( //price
                            '\$ ${product.price.toStringAsFixed(2)}',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold
                            ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            )
            : Row(
              children: <Widget>[
                Flexible(
                  flex: 1,
                  child: Image.network(
                    product.images[0],
                    fit: BoxFit.cover,
                    height: 250.0
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text( //title
                            product.title,
                            style: TextStyle( fontWeight: FontWeight.w500)
                        ),
                        Text( //price
                          'R\$ ${product.price.toStringAsFixed(2)}',
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            )
      ),
    );
  }
}
