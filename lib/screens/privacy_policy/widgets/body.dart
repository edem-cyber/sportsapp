import 'package:flutter/material.dart';

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ListView(
        children: [
          Text(
            "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eir mod tempor invidun Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed dia. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam no numy eirmod tempor invidun Lorem ipsum dolor sit amet, consetetur sadipsci ng elitr, sed dia. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidun Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed dia. Lorem ipsum dolor sit amet, consetetur sadipscing e litr, sed diam nonumy eirmod tempor invidun Lorem ipsum dolor sit amet, con setetur sadipscing elitr, sed dia. Lorem ipsum dolor sit amet, consetetur sadip scing elitr, sed diam nonumy eirmod tempor invidun Lorem ipsum dolor sit am et, consetetur sadipscing elitr, sed dia. Lorem ipsum dolor sit amet, consetetu r sadipscing elitr, sed diam nonumy eirmod tempor invidun Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed dia. Lorem ipsum dolor sit amet, con setetur sadipscing elitr, sed diam nonumy eirmod tempor invidun Lorem ipsu m dolor sit amet, consetetur sadipscing elitr, sed dia. Lorem ipsum dolor sit am et, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidun Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed dia. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam no numy eirmod tempor invidun Lorem ipsum dolor sit amet, consetetur sadipsci ng elitr, sed dia. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidun Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed dia. Lorem ipsum dolor sit amet, consetetur sadipscing e litr, sed diam nonumy eirmod tempor invidun Lorem ipsum dolor sit amet, con setetur sadipscing elitr, sed dia. Lorem ipsum dolor sit amet, consetetur sadip scing elitr, sed diam nonumy eirmod tempor invidun Lorem ipsum dolor sit am et, consetetur sadipscing elitr, sed dia. Lorem ipsum dolor sit amet, consetetu r sadipscing elitr, sed diam nonumy eirmod tempor invidun Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed dia. Lorem ipsum dolor sit amet, con setetur sadipscing elitr, sed diam nonumy eirmod tempor invidun Lorem ipsu m dolor sit amet, consetetur sadipscing elitr, sed dia.",
            style: Theme.of(context).textTheme.bodyText2,
          ),
        ],
      ),
    );
  }
}
