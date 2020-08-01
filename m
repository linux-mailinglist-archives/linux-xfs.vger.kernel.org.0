Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A90A523545A
	for <lists+linux-xfs@lfdr.de>; Sat,  1 Aug 2020 22:56:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726545AbgHAU4j (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sat, 1 Aug 2020 16:56:39 -0400
Received: from sonic302-55.consmr.mail.ne1.yahoo.com ([66.163.186.181]:41231
        "EHLO sonic302-55.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726477AbgHAU4j (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 1 Aug 2020 16:56:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1596315398; bh=5dfJpJ2n7jvaJeEqdG/Th7hZpF39HdOLqDHZltZR/a4=; h=Date:From:Reply-To:Subject:References:From:Subject; b=uabN743qgV6gDYS11QnYGDqq4PKO0KnLD+z04+Vn7VGrB0lam2u4QB2Kj8zSiAmUcWZ9harQy1wNbTz3t8PEKQHh7NZ+UdXSoKvxigTPtNLPSXHSgpmPmTgbq9WDIXbnz4Yal8AXkEcfxHVgoHVKhdTTIay8A8aJLqhqCBS3feYvcgiapL3EVhxw+dyEbrtZ5cj4c0cdUjw7lL3A28C9JU8nCpXS2IXwYuRLl+5nv/gkVt0loU/mwi3QbyWI07CiR3h69t75olbXUAhHJ2ShnXM0gM74NWKAeCBYmyvsYDowo+r0HCFGb5dDnKnRJt3u7hrDuyucR+n3WeuTOl3DSQ==
X-YMail-OSG: JYAOCnQVM1m0uxfQyAA.RgdO85J6yEIGOjtaIadmHQXe4yuom35xI3J0HvBfP4X
 LgqYyBNHaSN0TGHdxoRj7n73iszG6qMlhDIDhDuZNQb45obN8so6b58DOqbuqWgLukY.9atva5d4
 IBr_shHB7IrHdP4OJaG4lpUo_tuaMYLxQqllflSnB9hj_vPaZv8x7PfO3ImOq5l9FJFAIxvUzkdy
 t_USt1VIRoj8q_MiKA_KspJinGZjH9vNVdtSRdJqVk3JUOvUU.jlFR.IXdkyvXntNdXN_oy86.Rd
 g0Q29YrAZox0RJTeykV_9cthjzCbMTNaqPiemADYgmLOMozsdHgYzuAOpeVSV.hTXLkFeWPVcX_1
 LCpM6fVobTZIjW6FGW89euTjHqJ.NnUWVTNKsp42gJBoVsFY75Z9uwYUOKyONUeXerZEMUuzhwCL
 jp.ef8sxP0JZu8WwOcJg9tt0Zske_iYu81dFqBmlt581JW40mqji_mM3ukIBIjibYTF7AQocVGrI
 a8cDM69SKaUimfKZAYHmuaqB9HAyTxA0RtnFL6tTKsVUzw8z.3NM10O6FeYB__esVL.g84FJz3Cd
 p_AvBKTtgjisaAUS.cF_igsWPk2._XwJbwig1zwLtObQatyUGi0yP7F3mmxlK4XsKTmMXURK539k
 FpvV2hZ3SQamuYGdmg7caiZAtE01x6go7gWHdtfdFYF_NslZEmicHSRiM_2PbLbAbYj4o1n_mDWk
 FWoDxg8QTBLTh_sjD95_itIZOkhALmLTfoic1XKt1TjUjk3KfFdGVwZ2OODh2mwYWZhlIzzFXhSB
 KM2APGEXCtp4IhDF_88Z2GGvUNGduC76KNFuCk5b8xN_vs0yVp3LbfgiiQkRlqTDkUPER5pU21aT
 Puk28A0GIRR3EcvxPJAqbyGd.nkXxF9wg3z0ZYdBSftobKNftIQzt.8wqod2s7DrX.2WiEydcew4
 _0oE1B8LlFQthfAZHGqIki6lQ8LxnT1m3Otn1bQnGyIJLkvwGz2mP5lodmbAh4YVKTxYtlFkB6x3
 Wo0ljDIzXO5rRutboXQL0KfgCyqfY7miGK3WRYLeasgr2bEsnL_R1M3stW.51Qq6htVFclGprb9i
 w5EmLjrHGr8vzP9AwdiBdSiwK8nRI1k4lPH.FdjXxQ2cOhT.QRyi5N0jhdJiiOIOQABbhC.truQ0
 4MJvHONYt4E6JMGhhKYRBOQKT5fCLUGxUHCXvawk5Ncc63gdDiuatmhL5Dx9AD3DuO5Rj0izrADI
 mi3eK0GNvOrEVYQwZKUdN3LsSd4tW8e9K7o97BpQkPis1KhvATOpkaXbj.sCCZIm1Gh8GEYuYcbw
 sWak-
Received: from sonic.gate.mail.ne1.yahoo.com by sonic302.consmr.mail.ne1.yahoo.com with HTTP; Sat, 1 Aug 2020 20:56:38 +0000
Date:   Sat, 1 Aug 2020 20:54:38 +0000 (UTC)
From:   Michel D'Hooghe <aerrr02@gtaorg.in>
Reply-To: pay_rolldepartment@consultant.com
Message-ID: <2144501764.10598131.1596315278130@mail.yahoo.com>
Subject: RE
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <2144501764.10598131.1596315278130.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16271 YMailNodin Mozilla/5.0 (Windows NT 10.0; rv:78.0) Gecko/20100101 Firefox/78.0
To:     unlisted-recipients:; (no To-header on input)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



You have been allocated some funds by WORLD BANK GROUP' & Qatar 2022 FIFA WORLD CUP & you are advised to urgently respond to this email: (payrolldepartment100@consultant.com) for more clarifications.

Michel D'Hooghe (Sec. Zone Co-coordinator).
