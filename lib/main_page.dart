import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:wallpaper_app/model/model.dart';
import 'package:wallpaper_app/preview_page.dart';
import 'package:wallpaper_app/repo/repository.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Repository repo = Repository();
  int pageNumber = 1;

  ScrollController scrollController = ScrollController();
  TextEditingController textEditingController = TextEditingController();
  late Future<List<Images>> imagesList;
  String currentSearchQuery = "";

  List<String> categories = [
    "Nature",
    "Abstract",
    "Technology",
    "Cars",
    "Bike",
    "Mountains",
    "Dark",
    "Superheroes",
  ];

  void getImagesBySearch({required String searchQuery}) {
    currentSearchQuery = searchQuery; // Store the current search term
    pageNumber = 1; // Reset to page 1 when searching
    imagesList = repo.getImagesBySearchQuery(
      searchQuery: searchQuery,
      pageNumber: pageNumber,
    );
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    imagesList = repo.getImagesList(pageNumber: pageNumber);
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [Text("Wallpaper's "), Text("App")],
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        controller: scrollController,
        child: Column(
          children: [
            SizedBox(height: 5),
            SizedBox(
              height: 40,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextField(
                  controller: textEditingController,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9]')),
                  ],
                  onSubmitted: (value) {
                    getImagesBySearch(searchQuery: value);
                  },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 25),
                    labelText: "Search",
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    suffixIcon: Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: IconButton(
                        onPressed: () {
                          getImagesBySearch(
                            searchQuery: textEditingController.text,
                          );
                        },
                        icon: Icon(Icons.search),
                        splashColor: Colors.transparent,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
              height: 30,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: categories.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      getImagesBySearch(searchQuery: categories[index]);
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: Colors.grey, width: 1),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 0,
                          ),
                          child: Center(child: Text(categories[index])),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 10),
            FutureBuilder(
              future: imagesList,
              builder: ((context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return Center(child: Text("Something Went Wrong!"));
                  }
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        child: MasonryGridView.count(
                          controller: scrollController,
                          itemCount: snapshot.data?.length,
                          shrinkWrap: true,
                          mainAxisSpacing: 5,
                          crossAxisSpacing: 5,
                          crossAxisCount: 2,
                          itemBuilder: (context, index) {
                            double height = (index % 10 + 1) * 100;
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => PreviewPage(
                                          imageId:
                                              snapshot.data![index].imageId,
                                          imageUrl:
                                              snapshot
                                                  .data![index]
                                                  .imagePortraitPath,
                                        ),
                                  ),
                                );
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: CachedNetworkImage(
                                  fit: BoxFit.cover,
                                  height: height > 300 ? 300 : height,
                                  imageUrl:
                                      snapshot.data![index].imagePortraitPath,
                                  errorWidget:
                                      (context, url, error) =>
                                          const Icon(Icons.error),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        height: 50,
                        width: 300,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          child: MaterialButton(
                            onPressed: () {
                              pageNumber++;
                              if (currentSearchQuery.isEmpty) {
                                imagesList = repo.getImagesList(
                                  pageNumber: pageNumber,
                                );
                              } else {
                                imagesList = repo.getImagesBySearchQuery(
                                  searchQuery: currentSearchQuery,
                                  pageNumber: pageNumber,
                                );
                              }
                              setState(() {});
                            },
                            minWidth: double.infinity,
                            color: Colors.blue,
                            textColor: Colors.white,
                            child: Text("Load More"),
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              }),
            ),
          ],
        ),
      ),
    );
  }
}
