<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    <%@ taglib prefix="t" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ page import="java.util.Date" %>

    <%
    String name = "";
    String rev;
    String tmp ="[";
    String tmp1 ="[";
    String tmp2 ="[";
    String sensor_times ="[";
    String sensor_cost_data ="[";
    int active_sensor_count = 0;
    int inactive_sensor_count = 0;
    int service_sensor_count = 0;
    int total_sensor_count = 0;
    long total_revenue = 0;
    String act_status = "Active";
    String inact_status = "Inactive";
    String service_status = "Service";
    String q = request.getParameter("q");
    Date create_dt;
    Date last_update_dt;
    try {
         Class.forName("com.mysql.jdbc.Driver");
         Connection con = DriverManager.getConnection("jdbc:mysql://127.0.0.1:3306/sensordb", "root", "root");
         Statement smt = con.createStatement(); //Create Statement to interact
    
          
         ResultSet sen_stat = smt.executeQuery("select * from sensor_details");
         while (sen_stat.next()) {
           name = sen_stat.getString("sensor_status");
           if(name.equals(act_status)) {
        	  active_sensor_count = active_sensor_count + 1; 
           }
           else if(name.equals(inact_status)) {
        	  inactive_sensor_count = inactive_sensor_count + 1; 
           }
           else if(name.equals(service_status)) {
        	  service_sensor_count = service_sensor_count + 1; 
           }
         }
         total_sensor_count = active_sensor_count + inactive_sensor_count + service_sensor_count;
         
	     

	     			
         ResultSet sen_times= smt.executeQuery("select * from sensor_details");
         while (sen_times.next()) {
           name = sen_times.getString("sensor_id");
    	   create_dt = sen_times.getTimestamp("creation_date");
    	   last_update_dt = sen_times.getTimestamp("lastUpdated");
    	   long secs = (last_update_dt.getTime() - create_dt.getTime()) / 1000;
    	   long hours = secs / 3600; 
    	   long days = hours/24;
    	   rev = Long.toString(days);
    	   
           sensor_times = sensor_times + "[\"" + "Sensor ID-" + name + "\"," + rev + "],"; 
         }
         sensor_times=sensor_times+"]";	
	     
         ResultSet sen_cost= smt.executeQuery("select * from sensor_details");
         while (sen_cost.next()) {
           name = sen_cost.getString("sensor_id");
    	   create_dt = sen_cost.getTimestamp("creation_date");
    	   last_update_dt = sen_cost.getTimestamp("lastUpdated");
    	   int  cost = sen_cost.getInt("cost");
    	   long secs = (last_update_dt.getTime() - create_dt.getTime()) / 1000;
    	   long hours = secs / 3600; 
    	   long per_sensor_cost = (hours/24) * cost;
    	   rev = Long.toString(per_sensor_cost);
    	   total_revenue = total_revenue + per_sensor_cost;
    	   sensor_cost_data = sensor_cost_data + "[\"" + "Sensor ID-" + name + "\"," + rev + "],"; 
         }
         sensor_cost_data=sensor_cost_data+"]";	     
    
    
         con.close();
    } catch (Exception e) {
         e.printStackTrace();
    }
 %>
<html>
<head>
<head>

    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">

    <title>Sensor Cloud</title>

    <!-- Bootstrap Core CSS -->
    <link href="bower_components/bootstrap/dist/css/bootstrap.min.css" rel="stylesheet">

   <!-- MetisMenu CSS -->
    <link href="bower_components/metisMenu/dist/metisMenu.min.css" rel="stylesheet">

    <!-- Timeline CSS -->
    <link href="dist/css/timeline.css" rel="stylesheet">

    <!-- Custom CSS -->
    <link href="dist/css/sb-admin-2.css" rel="stylesheet">


    <!-- Morris Charts CSS -->
    <link href="bower_components/morrisjs/morris.css" rel="stylesheet">
    
    <!-- Custom Fonts -->
    <link href="bower_components/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">

    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.5.0/css/font-awesome.min.css">
    <!-- Ionicons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/ionicons/2.0.1/css/ionicons.min.css">

    <!-- iCheck -->
    <link rel="stylesheet" href="plugins/iCheck/flat/blue.css">
   
    <!-- jvectormap -->
    <link rel="stylesheet" href="plugins/jvectormap/jquery-jvectormap-1.2.2.css">
    <!-- Date Picker -->
    <link rel="stylesheet" href="plugins/datepicker/datepicker3.css">
    <!-- Daterange picker -->
    <link rel="stylesheet" href="plugins/daterangepicker/daterangepicker-bs3.css">
    <!-- bootstrap wysihtml5 - text editor -->
    <link rel="stylesheet" href="plugins/bootstrap-wysihtml5/bootstrap3-wysihtml5.min.css">
    <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
        <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
        <script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->

</head>

<body>

    <div id="wrapper">

        <!-- Navigation -->
        <nav class="navbar navbar-default navbar-static-top" role="navigation" style="margin-bottom: 0">
            <div class="navbar-header">
                <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
                    <span class="sr-only">Toggle navigation</span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                </button>
                <a class="navbar-brand" href="#">Mobile Sensor Cloud Admin</a>
            </div>
            <!-- /.navbar-header -->

            <ul class="nav navbar-top-links navbar-right">
                <!-- /.dropdown -->
                <li class="dropdown">
                    <a class="dropdown-toggle" data-toggle="dropdown" href="#">
                        <i class="fa fa-user fa-fw"></i>  <i class="fa fa-caret-down"></i>
                    </a>
                    <ul class="dropdown-menu dropdown-user">
                        <li><a href="#"><i class="fa fa-user fa-fw"></i> User Profile</a>
                        </li>
                        <li><a href="#"><i class="fa fa-gear fa-fw"></i> Settings</a>
                        </li>
                        <li class="divider"></li>
                        <li><a href="Logout"><i class="fa fa-sign-out fa-fw"></i> Logout</a>
                        </li>
                    </ul>
                    <!-- /.dropdown-user -->
                </li>
                <!-- /.dropdown -->
            </ul>
            <!-- /.navbar-top-links -->
            <div class="navbar-default sidebar" role="navigation">
                <div class="sidebar-nav navbar-collapse">
                    <ul class="nav" id="side-menu">
                       <li>
                            <a  class="active" href="Userdata"><i class="fa fa-dashboard fa-fw"></i> Dashboard</a>
                        </li>
                       <!--  <li>
                            <a href="${pageContext.request.contextPath}/SensorMap"><i class="fa fa-bar-chart-o fa-fw"></i> Sensor on Map<span class="fa arrow"></span></a>
                            
                             
                        </li> -->
                        <li>
                            <a href="Charts"><i class="fa fa-edit fa-fw"></i>Monitor Sensors</a>
                        </li>
                         <!-- <li>
                            <a href="SensorMap"><i class="fa fa-sitemap fa-fw"></i>Sensors' Location</a>
                        </li> -->
                         
                        <li>
                            <a href="viewSensors.jsp"><i class="fa fa-sitemap fa-fw"></i>Manage Sensors</a>
                        </li>
                        
                       <!--  <li>
                            <a href="Charts"><i class="fa fa-bar-chart-o fa-fw"></i>Temperature Data</a>
                        </li> -->
                        
                         <li>
                            <a href="billingUser.jsp"><i class="fa fa-table fa-fw"></i> Billing</a>
                        </li>
                    </ul>
                </div>
                <!-- /.sidebar-collapse -->
            </div>
            <!-- /.navbar-static-side -->
        </nav>

        <div id="page-wrapper">
            <div class="row">
                <div class="col-lg-12">
                    <h1 class="page-header">Dashboard</h1>
                </div>
                <!-- /.col-lg-12 -->
            </div>
            
            <!-- /.row -->
            <div class="row">
            
                <div class="col-lg-3 col-md-6">
                    <div class="panel panel-primary bg-maroon">
                        <div class="panel-heading bg-maroon">
                            <div class="row">
                                <div class="col-xs-3">
                                    <i class="fa fa-taxi fa-5x"></i>
                                </div>
                                <div class="col-xs-9 text-right">
                                    <div class="huge"><%=service_sensor_count%></div>
                                    <div><h3>Sensors Requiring Service</h3></div>
                                </div>
                            </div>
                        </div>
                        <a href="sensor_service_table_new.jsp">
                            <div class="panel-footer">
                                <span href="sensor_service_table_new.jsp" class="pull-left">View Details</span>
                                <span class="pull-right"><i class="fa fa-arrow-circle-right"></i></span>
                                <div class="clearfix"></div>
                            </div>
                        </a>
                    </div>
                </div>
                
          
                <div class="col-lg-3 col-md-6">
                    <div class="panel panel-primary">
                        <div class="panel-heading">
                            <div class="row">
                                <div class="col-xs-3">
                                    <i class="fa fa-taxi fa-5x"></i>
                                </div>
                                <div class="col-xs-9 text-right">
                                    <div class="huge"><%=total_sensor_count%></div>
                                    <div><h3>Total Number of Sensors</h3></div>
                                </div>
                            </div>
                        </div>
                        <a href="total_sensors_graph_new.jsp">
                            <div class="panel-footer">
                                <span href="total_sensors_graph_new.jsp" class="pull-left">View Details</span>
                                <span class="pull-right"><i class="fa fa-arrow-circle-right"></i></span>
                                <div class="clearfix"></div>
                            </div>
                        </a>
                    </div>
                </div>
                <div class="col-lg-3 col-md-6">
                    <div class="panel panel-red">
                        <div class="panel-heading">
                            <div class="row">
                              <div class="col-xs-3">
                                    <i class="fa fa-tasks fa-5x"></i>
                                </div>
                                <div class="col-xs-9 text-right">
                                    <div class="huge"><%=active_sensor_count%></div>
                                    <div><h3>Active Sensors</h3></div>
                                </div>
                            </div>
                        </div>
                        <a href="active_sensors_graph_new.jsp">
                            <div class="panel-footer">
                                <span href="active_sensors_graph_new.jsp" class="pull-left">View Details</span>
                                <span class="pull-right"><i class="fa fa-arrow-circle-right"></i></span>
                                <div class="clearfix"></div>
                            </div>
                        </a>
                    </div>
                </div>
                
                <div class="col-lg-3 col-md-6">
                    <div class="panel panel-yellow">
                        <div class="panel-heading">
                            <div class="row">
                                <div class="col-xs-3">
                                    <i class="fa fa-usd fa-5x"></i>
                                </div>
                                <div class="col-xs-9 text-right">
                                    <div class="huge">$<%=total_revenue%></div>
                                    <div><h3>Revenue</h3></div>
                                </div>
                            </div>
                        </div>
                        <a href="sensor_monthly_revenue_graph_new.jsp">
                            <div class="panel-footer">
                                <span "sensor_monthly_revenue_graph_new.jsp" class="pull-left">View Details</span>
                                <span class="pull-right"><i class="fa fa-arrow-circle-right"></i></span>
                                <div class="clearfix"></div>
                            </div>
                        </a>
                    </div>
                </div>
                
            </div>
            <div id="container" style="min-width: 400; height: 200; margin: 0 auto"></div>
            
                       <!-- Donut chart -->
          <div class="box box-primary">
            <div class="box-header with-border">
              <i class="fa fa-bar-chart-o"></i>

              <h3 class="box-title">Sensor Tracking</h3>

              <div class="box-tools pull-right">
                <button type="button" class="btn btn-box-tool" data-widget="collapse"><i class="fa fa-minus"></i>
                </button>
          
              </div>
            </div>
            <div class="box-body">
              <div id="donut-chart" style="height: 320px;"></div>
            </div>
            <!-- /.box-body-->
          </div>
            
                      <!-- BAR CHART - Sensor Active time -->
         <div data-brackets-id="15405" class="box box-primary">
            <div data-brackets-id="15406" class="box-header with-border">
              <i data-brackets-id="15407" class="fa fa-bar-chart-o"></i>

              <h3 data-brackets-id="15408" class="box-title">Sensor ID / Days Active</h3>

              <div data-brackets-id="15409" class="box-tools pull-right">
                <button data-brackets-id="15410" type="button" class="btn btn-box-tool" data-widget="collapse"><i data-brackets-id="15411" class="fa fa-minus"></i>
                </button>
              
              </div>
            </div>
            <div data-brackets-id="15414" class="box-body">
              <div data-brackets-id="15415" id="bar-chart2" style="height: 300px; padding: 0px; position: relative;"><canvas class="flot-base" width="866" height="375" style="direction: ltr; position: absolute; left: 0px; top: 0px; width: 693px; height: 300px;"></canvas><div class="flot-text" style="position: absolute; top: 0px; left: 0px; bottom: 0px; right: 0px; font-size: smaller; color: rgb(84, 84, 84);"><div class="flot-x-axis flot-x1-axis xAxis x1Axis" style="position: absolute; top: 0px; left: 0px; bottom: 0px; right: 0px; display: block;"><div class="flot-tick-label tickLabel" style="position: absolute; max-width: 99px; top: 283px; left: 32px; text-align: center;">January</div><div class="flot-tick-label tickLabel" style="position: absolute; max-width: 99px; top: 283px; left: 147px; text-align: center;">February</div><div class="flot-tick-label tickLabel" style="position: absolute; max-width: 99px; top: 283px; left: 272px; text-align: center;">March</div><div class="flot-tick-label tickLabel" style="position: absolute; max-width: 99px; top: 283px; left: 394px; text-align: center;">April</div><div class="flot-tick-label tickLabel" style="position: absolute; max-width: 99px; top: 283px; left: 512px; text-align: center;">May</div><div class="flot-tick-label tickLabel" style="position: absolute; max-width: 99px; top: 283px; left: 628px; text-align: center;">June</div></div><div class="flot-y-axis flot-y1-axis yAxis y1Axis" style="position: absolute; top: 0px; left: 0px; bottom: 0px; right: 0px; display: block;"><div class="flot-tick-label tickLabel" style="position: absolute; top: 270px; left: 8px; text-align: right;">0</div><div class="flot-tick-label tickLabel" style="position: absolute; top: 203px; left: 8px; text-align: right;">5</div><div class="flot-tick-label tickLabel" style="position: absolute; top: 135px; left: 1px; text-align: right;">10</div><div class="flot-tick-label tickLabel" style="position: absolute; top: 68px; left: 1px; text-align: right;">15</div><div class="flot-tick-label tickLabel" style="position: absolute; top: 0px; left: 1px; text-align: right;">20</div></div></div><canvas class="flot-overlay" width="866" height="375" style="direction: ltr; position: absolute; left: 0px; top: 0px; width: 693px; height: 300px;"></canvas></div>
            <!-- /.box-body-->
          </div>
          <!-- jQuery 2.2.3 -->
         </div>
         
                      <!-- BAR CHART - Sensor Cost -->
         <div data-brackets-id="15405" class="box box-primary">
            <div data-brackets-id="15406" class="box-header with-border">
              <i data-brackets-id="15407" class="fa fa-bar-chart-o"></i>

              <h3 data-brackets-id="15408" class="box-title">Sensor ID / Revenue (dollars)</h3>

              <div data-brackets-id="15409" class="box-tools pull-right">
                <button data-brackets-id="15410" type="button" class="btn btn-box-tool" data-widget="collapse"><i data-brackets-id="15411" class="fa fa-minus"></i>
                </button>
              
              </div>
            </div>
            <div data-brackets-id="15414" class="box-body">
              <div data-brackets-id="15415" id="bar-chart3" style="height: 300px; padding: 0px; position: relative;"><canvas class="flot-base" width="866" height="375" style="direction: ltr; position: absolute; left: 0px; top: 0px; width: 693px; height: 300px;"></canvas><div class="flot-text" style="position: absolute; top: 0px; left: 0px; bottom: 0px; right: 0px; font-size: smaller; color: rgb(84, 84, 84);"><div class="flot-x-axis flot-x1-axis xAxis x1Axis" style="position: absolute; top: 0px; left: 0px; bottom: 0px; right: 0px; display: block;"><div class="flot-tick-label tickLabel" style="position: absolute; max-width: 99px; top: 283px; left: 32px; text-align: center;">January</div><div class="flot-tick-label tickLabel" style="position: absolute; max-width: 99px; top: 283px; left: 147px; text-align: center;">February</div><div class="flot-tick-label tickLabel" style="position: absolute; max-width: 99px; top: 283px; left: 272px; text-align: center;">March</div><div class="flot-tick-label tickLabel" style="position: absolute; max-width: 99px; top: 283px; left: 394px; text-align: center;">April</div><div class="flot-tick-label tickLabel" style="position: absolute; max-width: 99px; top: 283px; left: 512px; text-align: center;">May</div><div class="flot-tick-label tickLabel" style="position: absolute; max-width: 99px; top: 283px; left: 628px; text-align: center;">June</div></div><div class="flot-y-axis flot-y1-axis yAxis y1Axis" style="position: absolute; top: 0px; left: 0px; bottom: 0px; right: 0px; display: block;"><div class="flot-tick-label tickLabel" style="position: absolute; top: 270px; left: 8px; text-align: right;">0</div><div class="flot-tick-label tickLabel" style="position: absolute; top: 203px; left: 8px; text-align: right;">5</div><div class="flot-tick-label tickLabel" style="position: absolute; top: 135px; left: 1px; text-align: right;">10</div><div class="flot-tick-label tickLabel" style="position: absolute; top: 68px; left: 1px; text-align: right;">15</div><div class="flot-tick-label tickLabel" style="position: absolute; top: 0px; left: 1px; text-align: right;">20</div></div></div><canvas class="flot-overlay" width="866" height="375" style="direction: ltr; position: absolute; left: 0px; top: 0px; width: 693px; height: 300px;"></canvas></div>
            <!-- /.box-body-->
          </div>
          <!-- jQuery 2.2.3 -->
         </div>
        
<%-- <t:forEach items="${sessionScope.sensor}"  var="row">  
		<div style="padding: 10px">          
            <div class="row" style="background-color: #e6e6e6">
              <div style="padding: 20px">
                <div class="col-lg-3 col-md-6">
                    <div class="panel panel-primary">
                        <div class="panel-heading">
                            <div class="row">
                              <!--   <div class="col-xs-3">
                                    <i class="fa fa-comments fa-5x"></i>
                                </div> -->
                                <div class="col-xs-9 text-right">
                                    <div class="huge">${row.sensor_tag_value }</div>
                                    <div>Sensor Name</div>
                                </div>
                            </div>
                        </div>
                        <a href="#">
                            <div class="panel-footer">
                                <span class="pull-left">View Details</span>
                                <span class="pull-right"><i class="fa fa-arrow-circle-right"></i></span>
                                <div class="clearfix"></div>
                            </div>
                        </a>
                    </div>
                </div>
                <div class="col-lg-3 col-md-6">
                    <div class="panel panel-green">
                        <div class="panel-heading">
                            <div class="row">
                            <!--  
                                <div class="col-xs-3">
                                    <i class="fa fa-tasks fa-5x"></i>
                                </div>
                                -->
                                <div class="col-xs-9 text-right">
                                    <div class="huge">${row.temp}C</div>
                                    <div>Temperature</div>
                                </div>
                            </div>
                        </div>
                        <a href="#">
                            <div class="panel-footer">
                                <span class="pull-left">View Details</span>
                                <span class="pull-right"><i class="fa fa-arrow-circle-right"></i></span>
                                <div class="clearfix"></div>
                            </div>
                        </a>
                    </div>
                </div>
                <div class="col-lg-3 col-md-6">
                    <div class="panel panel-yellow">
                        <div class="panel-heading">
                            <div class="row">
                            <!--      <div class="col-xs-3">
                                    <i class="fa fa-shopping-cart fa-5x"></i>
                                </div>
                                -->
                                <div class="col-xs-9 text-right">
                                    <div class="huge">${row.sensor_status}</div>
                                    <div>Status</div>
                                </div>
                            </div>
                        </div>
                        <a href="userCPuUtilization">
                            <div class="panel-footer">
                                <span class="pull-left">View Details</span>
                                <span class="pull-right"><i class="fa fa-arrow-circle-right"></i></span>
                                <div class="clearfix"></div>
                            </div>
                        </a>
                    </div>
                </div>
                <div class="col-lg-3 col-md-6">
                    <div class="panel panel-red">
                        <div class="panel-heading">
                            <div class="row">
                            <!--  
                                <div class="col-xs-3">
                                    <i class="fa fa-support fa-5x"></i>
                                </div>
                                -->
                                <div class="col-xs-9 text-right">
                                    <div class="huge">
                                    
                                    <t:set var="status" scope="session" value="${row.sensor_status}"></t:set>
                                    <t:choose>
                                    <t:when test="${status =='Running' }">
                                    <a href="StartStop?sensor_id=${row.sensor_id}&action=stop"><button type="button" class="btn btn-warning btn-lg">Stop</button></a>
                                    
                                    </t:when>
                                    <t:otherwise>
                             		<a href="StartStop?sensor_id=${row.sensor_id}&action=start"><button type="button" class="btn btn-success btn-lg">Start</button></a>
                                   	</t:otherwise>
                                   	</t:choose>
                                   	
                                   	
                                   	</div>
                                    <div>
                                		Manage
                               		</div>
                                </div>
                            </div>
                       </div>
                        <a href="#">
                            <div class="panel-footer">
                                <span class="pull-left">View Details</span>
                                <span class="pull-right"><i class="fa fa-arrow-circle-right"></i></span>
                                <div class="clearfix"></div>
                            </div>
                        </a>
					   </div>                     
                    
                </div>
               
            </div>
           </div> 
           </div>
</t:forEach> --%>            
            
            <!-- /.row -->
        </div>
        <!-- /#page-wrapper -->

    </div>
    <!-- /#wrapper -->

    <!-- jQuery -->
     <script src="bower_components/jquery/dist/jquery.min.js"></script>

    <!-- Bootstrap Core JavaScript -->
    <script src="bower_components/bootstrap/dist/js/bootstrap.min.js"></script>



    <!-- Morris Charts JavaScript -->
    <script src="bower_components/raphael/raphael-min.js"></script>

  
    
    <!-- FLOT CHARTS -->
<script src="https://cdn.jsdelivr.net/jquery.flot/0.8.3/jquery.flot.min.js"></script>
<!-- FLOT RESIZE PLUGIN - allows the chart to redraw when the window is resized -->
<script src="plugins/flot/jquery.flot.resize.min.js"></script>
<!-- FLOT PIE PLUGIN - also used to draw donut charts -->
<script src="plugins/flot/jquery.flot.pie.min.js"></script>
<!-- FLOT CATEGORIES PLUGIN - Used to draw bar charts -->
<script src="plugins/flot/jquery.flot.categories.min.js"></script>
    
<script>
$(document).ready(function () {

	
    /*
     * DONUT CHART
     * -----------
     */

    var donutData = [
      {label: "Active Sensors", data: <%=active_sensor_count%>, color: "#800000"},
      {label: "Idle sensors", data: <%=inactive_sensor_count%>, color: "#808080"}
    ];
    $.plot("#donut-chart", donutData, {
      series: {
        pie: {
          show: true,
          radius: 1,
          innerRadius: 0.5,
          label: {
            show: true,
            radius: 0.78,
            formatter: labelFormatter,
            threshold: 0.01
          }

        }
      },
      legend: {
        show: true
      }
    });
    /*
     * END DONUT CHART
     */
     
    /*
     * BAR CHART 2
     * ---------
     */

    var bar_data2 = {
      data: <%=sensor_times%> ,
      color: "#33aaff",
    };
    $.plot("#bar-chart2", [bar_data2], {
      grid: {
        borderWidth: 1,
        hoverable: true,
        clickable: true,
        borderColor: "#f3f3f3",
        tickColor: "#f3f3f3"
      },
      series: {
        bars: {
          show: true,
          barWidth: 0.22,
          align: "center"
        }
      },
      xaxis: {
        mode: "categories",
        tickLength: 0
      },
      yaxis: {
         min: 0,
         max: 1000
      }
    });
    $("#bar-chart2").UseTooltip();
    /* END BAR CHART 2 */
    
    /*
     * BAR CHART 3
     * ---------
     */

    var bar_data3 = {
      data: <%=sensor_cost_data%> ,
      color: "#ff69b4",
    };
    $.plot("#bar-chart3", [bar_data3], {
      grid: {
        borderWidth: 1,
        hoverable: true,
        clickable: true,
        borderColor: "#f3f3f3",
        tickColor: "#f3f3f3"
      },
      series: {
        bars: {
          show: true,
          barWidth: 0.22,
          align: "center"
        }
      },
      xaxis: {
        mode: "categories",
        tickLength: 0
      },
      yaxis: {
         min: 0,
         max: 25000
      }
    });
    $("#bar-chart3").UseTooltip();
    /* END BAR CHART 3 */
    
  });

  /*
   * Custom Label formatter
   * ----------------------
   */
    
    var previousPoint = null, previousLabel = null;
    
    $.fn.UseTooltip = function () {
        $(this).bind("plothover", function (event, pos, item) {
            if (item) {
                if ((previousLabel != item.series.label) || (previousPoint != item.dataIndex)) {
                    previousPoint = item.dataIndex;
                    previousLabel = item.series.label;
                    $("#tooltip").remove();

                    var x = item.datapoint[0];
                    var y = item.datapoint[1];

                    var color = item.series.color;

                    //console.log(item.series.xaxis.ticks[x].label);                

                    showTooltip(item.pageX,
                    item.pageY,
                    color,
                    "<strong>" + item.series.xaxis.ticks[x].label + "</strong><br>" + "<strong>:" + y + "</strong>");
                }
            } else {
                $("#tooltip").remove();
                previousPoint = null;
            }
        });
    };

    function showTooltip(x, y, color, contents) {
        $('<div id="tooltip">' + contents + '</div>').css({
            position: 'absolute',
            display: 'none',
            top: y - 1,
            left: x - 1,
            border: '2px solid ' + color,
            padding: '3px',
            'font-size': '14px',
            'border-radius': '7px',
            'background-color': '#fff',
            'font-family': 'Verdana, Arial, Helvetica, Tahoma, sans-serif',
            opacity: 0.9
        }).appendTo("body").fadeIn(200);
    }
  function labelFormatter(label, series) {
    return '<div style="font-size:13px; text-align:center; padding:2px; color: #fff; font-weight: 600;">'
        + label
        + "<br>"
        + Math.round(series.percent) + "%</div>";
  }
</script>
</body>

</html>