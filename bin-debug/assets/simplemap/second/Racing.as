﻿package {
			//gamesprite 中的car的坐标转换为全局坐标
			//判断汽车下一移动位置如果不在路上,减速行为发生在下一移动位置,
		//检查road上所有的点是否被经过,次逻辑目的是限制汽车在road附近行驶,防止穿越行为;