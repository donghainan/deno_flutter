import client from "../database/database.ts";
import { User } from "../models/user.ts";

class UserRepo {
  static async findAll() {
    let result = await client.query(
      "select * from user where delFlag = 0",
    );
    return result;
  }
  static async save(user: User) {
    let result = await client.execute(
      `
    insert into user(userName,passWord,type,delFlag) values(?,?,?,?)
    `,
      [user.userName, user.passWord, user.type,user.delFlag],
    );
    return result;
  }
}

export default UserRepo;
