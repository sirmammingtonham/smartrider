import 'package:flutter/material.dart';


class BusSchedule extends StatefulWidget {
  @override
  BusScheduleState createState() => BusScheduleState();
}

class BusScheduleState extends State<BusSchedule> {
  @override
    Widget build(BuildContext context) {
      return MaterialApp (
        home: DefaultTabController (
        length: 12,
        child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text('BUS SCHEDULE',style: TextStyle(fontSize: 16.0),),
              bottom: PreferredSize(
                  child: TabBar(
                      isScrollable: true,
                      unselectedLabelColor: Colors.white.withOpacity(0.3),
                      indicatorColor: Colors.white,
                      tabs: [
                        Tab(
                          child: Text('Route 22'),
                        ),
                        Tab(
                          child: Text('Route 80'),
                        ),
                        Tab(
                          child: Text('Route 85'),
                        ),
                        Tab(
                          child: Text('Route 87'),
                        ),
                        Tab(
                          child: Text('Route 182'),
                        ),
                        Tab(
                          child: Text('Route 224'),
                        ),
                        Tab(
                          child: Text('Route 286'),
                        ),
                        Tab(
                          child: Text('Route 289'),
                        ),
                        Tab(
                          child: Text('Route 522'),
                        ),
                        Tab(
                          child: Text('Route 808'),
                        ),
                        Tab(
                          child: Text('Route 809'),
                        ),
                        Tab(
                          child: Text('Route 815'),
                        )
                        
                      ]),
                      
                  preferredSize: Size.fromHeight(30.0)),
              actions: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                ),
              ],
            ),
            body: TabBarView(
              children: [
                Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  TableRow(children: [
                     
                    Text(
                      'Madison Ave & Empire State Plaza',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                  ]),
                  TableRow(children: [
                     
                    Text(
                      'South Pearl Station',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                  ]),
                  TableRow(children: [
                     
                    Text(
                      'Broadway & N. 3rd St',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                  ]),
                  TableRow(children: [
                     
                    Text(
                      'Broadway & Morgan Linen',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                  ]),
                  TableRow(children: [
                     
                    Text(
                      '587 Broadway (The Village One Apts)',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                  ]),
                  TableRow(children: [
                     
                    Text(
                      '2nd Ave & 18th St',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                  ]),
                  TableRow(children: [
                     
                    Text(
                      '4th St & Fulton St',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                  ]),
                ],
              ),
              Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  TableRow(children: [
                     
                    Text(
                      'River St & Front St',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                  ]),
                  TableRow(children: [
                     
                    Text(
                      '4th St & Congress St',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                  ]),
                  TableRow(children: [
                     
                    Text(
                      '6th Ave & Hoosick St',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                  ]),
                  TableRow(children: [
                     
                    Text(
                      '5th Ave & 112th St',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                  ]),
                  TableRow(children: [
                     
                    Text(
                      '8th Ave & Northern Dr (Corliss Park)',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                  ]),
                ],
              ),
              Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  TableRow(children: [
                     
                    Text(
                      'Bloomingrove Rd & VRM',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                  ]),
                  TableRow(children: [
                     
                    Text(
                      'Hudson Valley Community College',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                  ]),
                  TableRow(children: [
                     
                    Text(
                      'La Salle Institute',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                  ]),
                  TableRow(children: [
                     
                    Text(
                      'Cottage St & Marvin Ave',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                  ]),
                  TableRow(children: [
                     
                    Text(
                      '4th St & Canal St',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                  ]),
                  TableRow(children: [
                     
                    Text(
                      '4th St & Fulton St',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                  ]),
                  TableRow(children: [
                     
                    Text(
                      'River St & Hutton St',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                  ]),
                  TableRow(children: [
                     
                    Text(
                      '2nd Ave & 112th St',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                  ]),
                  TableRow(children: [
                     
                    Text(
                      '2nd Ave & 124th St',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                  ]),
                  TableRow(children: [
                     
                    Text(
                      'Broad St & 6th St',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                  ]),
                ],
              ),
              Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  TableRow(children: [
                     
                    Text(
                      'River St & Front St',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                  ]),
                  TableRow(children: [
                     
                    Text(
                      '4th St & Fulton St',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                  ]),
                  TableRow(children: [
                     
                    Text(
                      'Hoosick St & 6th Ave',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                  ]),
                  TableRow(children: [
                     
                    Text(
                      'Burdett Ave & Samaritan Hospital',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                  ]),
                  TableRow(children: [
                     
                    Text(
                      '15th St & RPI Walk Over Bridge',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                  ]),
                  TableRow(children: [
                     
                    Text(
                      '2212 Burdett Ave',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                  ]),
                  TableRow(children: [
                     
                    Text(
                      '716 Hoosick Rd (Price Chopper)',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                  ]),
                  TableRow(children: [
                     
                    Text(
                      'Walmart - Brunswick Plaza',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                  ]),
                ],
              ),
              Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  TableRow(children: [
                     
                    Text(
                      'Albany Bus Terminal',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                  ]),
                  TableRow(children: [
                     
                    Text(
                      'State St & Lodge St - S. Pearl Station',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                  ]),
                  TableRow(children: [
                     
                    Text(
                      'Washington Ave & Lark St - Lark/Library Station',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                  ]),
                  TableRow(children: [
                     
                    Text(
                      '600 Northern Blvd (Memorial Hospital)',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                  ]),
                  TableRow(children: [
                     
                    Text(
                      'Van Rensselaer Blvd & Wards Ln',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                  ]),
                  TableRow(children: [
                     
                    Text(
                      'New Loudon Rd & Siena College',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                  ]),
                  TableRow(children: [
                     
                    Text(
                      'Shoppes of Latham (Walmart)',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                  ]),
                  TableRow(children: [
                     
                    Text(
                      'Latham Farms',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                  ]),
                  TableRow(children: [
                     
                    Text(
                      'Columbia St & Baker Ave',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                  ]),
                  TableRow(children: [
                     
                    Text(
                      'Vliet Blvd & Garner St',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                  ]),
                  TableRow(children: [
                     
                    Text(
                      'Remsen St & Cayuga St',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                  ]),
                  TableRow(children: [
                     
                    Text(
                      'Arch St & George St',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                  ]),
                  TableRow(children: [
                     
                    Text(
                      '2nd Ave & 21st St',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                  ]),
                  TableRow(children: [
                     
                    Text(
                      '4th St & Fulton St',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                  ]),
                ],
              ),
              Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  TableRow(children: [
                     
                    Text(
                      'Madison Ave & Empire State Plaza',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                  ]),
                  TableRow(children: [
                     
                    Text(
                      'S. Swan St & Washington Ave',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                  ]),
                  TableRow(children: [
                     
                    Text(
                      'State St & S. Pearl St - S. Pearl Station',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                  ]),
                  TableRow(children: [
                     
                    Text(
                      'Broadway & Peter D Kiernan Plaza',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                  ]),
                  TableRow(children: [
                     
                    Text(
                      'Defreestville Park & Ride',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                  ]),
                  TableRow(children: [
                     
                    Text(
                      '104 Van Renss Sq (ShopRite N. Greenbush)',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                  ]),
                  TableRow(children: [
                     
                    Text(
                      'Rt 4 & Jordan Rd (Rensselaer TechPark)',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                  ]),
                  TableRow(children: [
                     
                    Text(
                      'Hudson Valley Community College',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                  ]),
                  TableRow(children: [
                     
                    Text(
                      '4th St & Canal St',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                  ]),
                  TableRow(children: [
                     
                    Text(
                      '4th St & Fulton St',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                  ]),
                ],
              ),
              Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  TableRow(children: [
                     
                    Text(
                      'Vanderheyden Hall',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                  ]),
                  TableRow(children: [
                     
                    Text(
                      'Main Ave & Atlantic Ave',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                  ]),
                  TableRow(children: [
                     
                    Text(
                      'Pawling Ave & Spring Ave',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                  ]),
                  TableRow(children: [
                     
                    Text(
                      'Myrtle Ave',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                  ]),
                  TableRow(children: [
                     
                    Text(
                      'Congress St & 15th St',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                  ]),
                  TableRow(children: [
                     
                    Text(
                      'Sage Ave & Anderson Field',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                  ]),
                  TableRow(children: [
                     
                    Text(
                      'River St & Front St',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                  ]),
                  TableRow(children: [
                     
                    Text(
                      '4th St & Fulton St',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                  ]),
                  TableRow(children: [
                     
                    Text(
                      'Sage Ave @ 87 Gymnasium PE Building',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                  ]),
                  TableRow(children: [
                     
                    Text(
                      'Sunset Terr & Forsyth Dr',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                  ]),
                ],
              ),
              Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  TableRow(children: [
                     
                    Text(
                      'Project St & Madison Ave',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                  ]),
                  TableRow(children: [
                     
                    Text(
                      'Myrtle Ave',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                  ]),
                  TableRow(children: [
                     
                    Text(
                      'Congress St & 15th St	',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                  ]),
                  TableRow(children: [
                     
                    Text(
                      '4th St & Fulton St',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                  ]),
                  TableRow(children: [
                     
                    Text(
                      'Sage Ave @ 87 Gymnasium PE Building',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                  ]),
                  TableRow(children: [
                     
                    Text(
                      '15th St & Massachusetts Ave',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                  ]),
                ],
              ),
              Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  TableRow(children: [
                     
                    Text(
                      'Empire State Plaza Concourse',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                  ]),
                  TableRow(children: [
                     
                    Text(
                      'S. Swan St & Washington Ave',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                  ]),
                  TableRow(children: [
                     
                    Text(
                      'State St & S. Pearl St - S. Pearl Station',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                  ]),
                  TableRow(children: [
                     
                    Text(
                      'Broadway & Peter D Kiernan Plaza',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                  ]),
                  TableRow(children: [
                     
                    Text(
                      '2nd Ave & 21st St',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                  ]),
                  TableRow(children: [
                     
                    Text(
                      '4th St & Fulton St',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                  ]),
                  TableRow(children: [
                     
                    Text(
                      'Remsen St & Cayuga St',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                  ]),
                  TableRow(children: [
                     
                    Text(
                      'Mohawk St & Vliet St',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                  ]),
                  TableRow(children: [
                     
                    Text(
                      'Manor Sites Apt',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                  ]),
                  TableRow(children: [
                     
                    Text(
                      'Vliet Blvd & Willowbrook Ln',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                  ]),
                  TableRow(children: [
                     
                    Text(
                      'Vliet Blvd & Simmons Ave',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                  ]),
                  TableRow(children: [
                     
                    Text(
                      'Columbia St & Main St',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                  ]),
                ],
              ),
              Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  TableRow(children: [
                     
                    Text(
                      'Stuyvesant Plaza (US Post Office)',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                  ]),
                  TableRow(children: [
                     
                    Text(
                      'Broadway & Hudson Ave - Broadway Station',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                  ]),
                  TableRow(children: [
                     
                    Text(
                      'East St & Herrick St (Rensselaer Rail Station)',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                  ]),
                  TableRow(children: [
                     
                    Text(
                      '3rd St & Washington Ave',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                  ]),
                  TableRow(children: [
                     
                    Text(
                      'Defreestville Park & Ride',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                  ]),
                  TableRow(children: [
                     
                    Text(
                      'La Salle Institute',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                  ]),
                ],
              ),
              Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  TableRow(children: [
                     
                    Text(
                      '468 2nd Ave',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                  ]),
                  TableRow(children: [
                     
                    Text(
                      '20 N. Pearl St (Walgreens Shelter)',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                  ]),
                  TableRow(children: [
                     
                    Text(
                      'Broadway & Morgan Linen',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                  ]),
                  TableRow(children: [
                     
                    Text(
                      'Broadway & 13th St',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                  ]),
                  TableRow(children: [
                     
                    Text(
                      'Albany St & George St',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                  ]),
                  TableRow(children: [
                     
                    Text(
                      'Catholic Central High School',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                  ]),
                ],
              ),
              Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  TableRow(children: [
                     
                    Text(
                      'Walmart - Brunswick Plaza',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                  ]),
                  TableRow(children: [
                     
                    Text(
                      '1541 Broadway (Senior Citizen Center)',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                  ]),
                  TableRow(children: [
                     
                    Text(
                      '500 16th St (Henratta Apartments)',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                  ]),
                  TableRow(children: [
                     
                    Text(
                      'Troy Towers',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                  ]),
                  TableRow(children: [
                     
                    Text(
                      'Burns Apartments (Troy Shopping Bus)',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                  ]),
                  TableRow(children: [
                     
                    Text(
                      'Kennedy Towers (Troy Shopping Bus)',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                  ]),
                  TableRow(children: [
                     
                    Text(
                      '6th Ave & Federal (O Neill Apts)',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                  ]),
                  TableRow(children: [
                     
                    Text(
                      '41 114th St (Lansingburgh Apartments)',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                  ]),
                  TableRow(children: [
                     
                    Text(
                      '2nd Ave & 115th St',
                      textScaleFactor: 1.25,
                      textAlign: TextAlign.left
                    ),
                  ]),
                ],
              ),
              ])),
        )
      );
    }
}
