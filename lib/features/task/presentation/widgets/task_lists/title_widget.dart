import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TitleWidget extends StatelessWidget {
  const TitleWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        children: [
          const Expanded(child: Divider(thickness: 2)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(text: 'Tasks ', style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w800, 
                    fontSize: 30, 
                    color: Colors.grey.shade800, 
                  )), 
                  TextSpan(text: "Lists", style: GoogleFonts.roboto(
                    fontSize: 30, 
                    color: Colors.grey.shade500, 
                    fontWeight: FontWeight.w300
                  )),
                ]
              )
            )
          ),
          const Expanded(child: Divider(thickness: 2)),
        ],
      )
    );
  }
}