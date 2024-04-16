import Cocoa
import GSS



//func newKlist() {
//    var minStat = OM_uint32()
//
//    let err = gss_iter_creds(&minStat, 0, nil) { (gssOID, gssCred) in
//        var foo =  OM_uint32()
//        var name2: gss_name_t?
//        var buffer: gss_buffer_t?
//        gss_inquire_cred(&foo, gssCred, &name2, nil, nil, nil)
//    }
//}



func decodeGssStatus<T: BinaryInteger>(_ status: T) -> String {
    var minorStatus = OM_uint32()
    var messageContent = OM_uint32()
    var stringContent = gss_buffer_desc_struct()
    defer {gss_release_buffer(&minorStatus, &stringContent)}
    
    gss_display_status(&minorStatus,
                       UInt32(status),
                       GSS_C_GSS_CODE,
                       nil,
                       &messageContent,
                       &stringContent)
    
    guard let gssStatus = String(data: Data(bytes: stringContent.value, count: stringContent.length), encoding: .utf8) else { return "" }
    return gssStatus
}

func gssMechs() {
    var minorStatus = OM_uint32()
    var oidSet: gss_OID_set!
    var stringContent = gss_buffer_desc_struct()
    defer {gss_release_oid_set(&minorStatus, &oidSet)}
    
    let status = gss_indicate_mechs(&minorStatus, &oidSet)
    if GSS_S_COMPLETE != gss_indicate_mechs(&minorStatus, &oidSet) {
        print(decodeGssStatus(status))
        return
    }
    
    let oids = Array(UnsafeBufferPointer(start: oidSet.pointee.elements, count: oidSet.pointee.count))
    for i in 0..<oids.count {
        var oid = oids[i]
        print("OID Bytes " + oid.elements.debugDescription)
        gss_oid_to_str(&minorStatus,
                       &oid,
                       &stringContent)
        
        let str = String(data: Data(bytes: stringContent.value, count: stringContent.length), encoding: .utf8)
        print("OID String: " + str! + "\n")
    }
}

gssMechs()

