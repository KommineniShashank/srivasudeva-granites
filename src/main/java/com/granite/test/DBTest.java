package com.granite.test;

import java.sql.Connection;
import com.granite.util.DBUtil;

public class DBTest {

    public static void main(String[] args) {
        Connection con = DBUtil.getConnection();

        if (con != null) {
            System.out.println("✅ Database Connected Successfully");
        } else {
            System.out.println("❌ Database Connection Failed");
        }
    }
}
