package sfs2x.extension.egame.sever.responseData;

import com.smartfoxserver.v2.entities.data.SFSArray;
import com.smartfoxserver.v2.entities.data.SFSObject;


/**
 * @author Administrator
 * @version 1.0
 * @created 27-七月-2016 17:11:49
 */
public class E109SangongResponse extends EGameResponse {

	public E109SangongResponse(){

	}

	/**
	 * 
	 * @exception Throwable Throwable
	 */
	public void finalize()
	  throws Throwable{

	}

	/**
	 * 
	 * @param so    so
	 */
	public SFSObject responseData(SFSObject outData){
		outData.putInt("state", 0);
		SFSArray betList = new SFSArray();
		outData.putSFSArray("betList", betList);
		SFSObject betList_so = new SFSObject();
		betList.addSFSObject(betList_so);
		betList_so.putInt("id", 3);
		betList_so.putDouble("money", 1.9);
		betList_so.putInt("type", 8);
		outData.putDouble("balance", 338.2);
		return outData;
	}
}//end E109SangongResponse