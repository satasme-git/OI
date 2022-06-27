import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:oi/controller/vehicle_controller.dart';
import 'package:oi/providers/map/vehicle_provider.dart';
import 'package:provider/provider.dart';

import '../../../../providers/map/location_provider.dart';

class CustomVehicleCard extends StatelessWidget {
  const CustomVehicleCard({
    required this.height,
    Key? key,
  }) : super(key: key);

  final double height;

  @override
  Widget build(BuildContext context) {
    return Consumer2<LocationProvider, VehicleProvider>(
      builder: (context, value, value2, child) {
        return Container(
          margin: EdgeInsets.only(left: 10),
          height: height,
          child: ListView.builder(
              itemCount: value2.getVehicle.length, //value.getVehicle.length,
              scrollDirection: Axis.horizontal,
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return VehicleTile(
                  imgb: value2.getVehicle[index].imgdark.toString(),
                  imgl: value2.getVehicle[index].imglight.toString(),
                  title: value2.getVehicle[index].type.toString(),
                  distance: value.getDistance,
                  price: value2.getVehicle[index].price,
                  index: index,
                  vehicle: value2,
                  location: value,
                  point: value2.getVehicle[index].points,
                );
              }),
        );
      },
    );
  }
}

class VehicleTile extends StatefulWidget {
  VehicleTile({
    required this.imgb,
    required this.imgl,
    required this.title,
    required this.distance,
    required this.price,
    required this.index,
    required this.vehicle,
    required this.location,
    required this.point,
    Key? key,
  }) : super(key: key);

  final String imgb;
  final String imgl;
  final String title;
  final double distance;
  final double? price;
  final int? index;
  final VehicleProvider vehicle;
  final LocationProvider location;
  final double? point;

  @override
  State<VehicleTile> createState() => _VehicleTileState();
}

class _VehicleTileState extends State<VehicleTile> {
  @override
  void initState() {
    super.initState();
  }

  abc(abc) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      child: InkWell(
        onTap: () {
          widget.vehicle.setIsVisible(widget.index!);
          widget.location.getAllDrivers(widget.index!);
        },
        child: Container(
          width: 125,
          height: 160,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: widget.vehicle.isSelected == widget.index
                  ? Colors.black
                  : Colors.white,
              width: 0.5,
            ),
          ),
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("IN 21 mins" + widget.index.toString()),
                SizedBox(
                  height: 8,
                ),
                Image.network(
                  widget.vehicle.isSelected == widget.index
                      ? widget.imgb
                      : widget.imgl,
                  height: 25,
                  fit: BoxFit.fill,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                            Colors.amberAccent),
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                double.parse(loadingProgress.expectedTotalBytes
                                    .toString())
                            : null,
                      ),
                    );
                  },
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Icon(
                      MaterialCommunityIcons.account_outline,
                      size: 18,
                      color: Colors.grey,
                    ),
                    Text("2")
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: new Divider(
                    color: Colors.grey,
                  ),
                ),
                Text(
                  "LKR " +
                      (widget.distance * double.parse(widget.price.toString()))
                          .toStringAsFixed(2)
                          .toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Row(
                  children: [
                    Icon(
                      MaterialCommunityIcons.star,
                      color: Colors.amber,
                    ),
                    Text(
                      "Earn ${widget.point} stars",
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
