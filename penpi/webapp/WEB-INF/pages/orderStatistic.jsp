<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
     <%@ include file="/base.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script src="http://cdn.hcharts.cn/highcharts/highcharts.js"></script>
<title>Insert title here</title>
<script type="text/javascript">
function  submitformSelect(){
	var type = document.getElementById("type");
	if(type.value == 0){
		$.ajax({  
		       type:'post', 
		       url:'${pageContext.request.contextPath}/admin/order/statStatistic.do',  
		       scriptCharset:'utf-8',
		
		       data:{},  
		       success:function(data){//返回json结果  
		   
			    	  var jsonObj = eval("("+data+")");
			       		 
			       		$('#container').highcharts({
			       		    chart: {
			       		        plotBackgroundColor: null,
			       		        plotBorderWidth: null,
			       		        plotShadow: false
			       		    },
			       		    title: {text: '订单状态比例'},//这里是标题
			       		    tooltip: {
			       		        pointFormat: '{series.name}: <b>{point.percentage}%</b>',  
			       		    },
			       		    credits: {    
			       		        enabled:false    //去掉水印     
			       		    },
			       		    plotOptions: {        //饼外面拉出的黑线和文字
			       		        pie: {
			       		            allowPointSelect: true,
			       		            cursor: 'pointer',
			       		            dataLabels: {
			       		              enabled: true,        //设为false，不显示:饼外面拉出的黑线和文字
			       		              color: '#000000',
			       		              connectorColor: '#000000',
			       		              format: '<b>{point.name}</b>: {point.percentage} %'
			       		            }
			       		        }
			       		    },
			       		    series: [{
			       		            type: 'pie',
			       		           
			       		            colors: ['#1ccb6a','#f7ef1e','#7cb5ec','#434348','#f7a35c','#8085e9'],//指定颜色
			       		            data: [
			       		             ['发单',Number(jsonObj.hasSendStat)],
			       		                ['已抢',Number(jsonObj.hasTake)],
			       		             	['交付',Number(jsonObj.takePpay)],
			       		          		['支付',Number(jsonObj.pay)],
			       		       			['完成',Number(jsonObj.finish)],
			       		    			['异常',Number(jsonObj.exception)],
			       		            ]
			       		        }]
			       		    }); 	 	        
		       }
		     
		   	
		   });
		
		
		
	}
	
}
</script>
</head>
<body>

 <div class="panel-body" style="padding-bottom:0px;width:1200px;height:50px;padding-left:50px;">
	<div class="panel panel-default"  >
		<div class="panel-heading" >用户管理 &nbsp; &nbsp;>> &nbsp; &nbsp; 数据统计</div>
	</div>
	 
			<select  class="selectpicker" id="type" name="type" data-width="auto" onchange="submitformSelect()">
		<option value="-1" >請選擇</option>
		<option value="0" >订单状态比例</option>
		  <option value="1" ></option>
		  <option value="2" ></option>
	</select>
	
	<div id="container" style="width: 600px;height:400px;"></div>
 
    
 
	
  
  </div>
 
 
</body>
</html>