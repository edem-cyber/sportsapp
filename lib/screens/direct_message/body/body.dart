import 'package:flutter/material.dart';

class Body extends StatefulWidget {
  final String? id, name, username, image;
  const Body({super.key, this.id, this.name, this.username, this.image});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("${widget.id}, ${widget.name}, ${widget.username}, ${widget.image}");
  }

  @override
  Widget build(BuildContext context) {
    // chat page body
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          // chat page header
          Container(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                // chat page header image

                // chat page header name
                Container(
                  padding: const EdgeInsets.only(left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.name ?? "Name",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        widget.username!,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // chat page messages
          Expanded(
            child: Container(
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Container(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            "Hello",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          // chat page input
          Container(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                // chat page input textfield
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Type a message",
                      ),
                    ),
                  ),
                ),
                // chat page input send button
                Container(
                  padding: const EdgeInsets.only(left: 10),
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.send),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
