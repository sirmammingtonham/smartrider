import 'package:flutter/material.dart';
import 'package.provider/provider.dart';
import 'package:smartrider/user.dart'

class UserList extends StatefulWidget {
	@override
	_UserListState createState() => _UserListState();
}


class _UserListState extends State<UserList> {
	@override
	Widget build(Buildcontext context){

		final users = Provider.of<List<User>>(context);
		users.forEach((user){

			print(user.name);
			print(user.rin);
			print(user.userType);

		});
		

		return Container(


		);

	}
}