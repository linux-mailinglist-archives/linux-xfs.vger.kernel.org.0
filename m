Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E30F01C1179
	for <lists+linux-xfs@lfdr.de>; Fri,  1 May 2020 13:25:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728616AbgEALZi (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 1 May 2020 07:25:38 -0400
Received: from sonic301-31.consmr.mail.ne1.yahoo.com ([66.163.184.200]:35942
        "EHLO sonic301-31.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728575AbgEALZi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 May 2020 07:25:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1588332336; bh=KpLOSNk7Dsb2atJvabHeqrmdZdu2sv994fIPrqoYb3o=; h=Date:From:Reply-To:Subject:References:From:Subject; b=cazs6XcLB0XL5gAiGB6ReiO0dE92Vk16cw0chozUCztRTsHoeR5Kl2i0tAISCVOj9ihN1sEH6BvCBwfvzBAiCb2dSaJ9GGQ8mgww9MaPGvbyIUJXe10EKjE3wyMS28awYnw0v7yeTKWpKiN0Ftlf3qogFcTyCI8Y38XQY+UnGdI6V2p1+kzcodo71OOy4bhKYLVJeb5HgDBCPTGVVITblF337Pz08wjHg9/5gduykrmTPSxQPOjj2KvXElvI1/I5zOeOSq0PxbTWhvOeNDukM0ETwZo+H4HzTAru4fYTtmccKEJ1nQVlJHkPfIYioql6C0E2kO7Z+MTnE6wXvnf5WA==
X-YMail-OSG: 8svnoKMVM1n30d45gjZSjW5wLm7Ne18k0A97VC3XhoDMCna9nt9FHi4r_9BTRjS
 V57n41YaVAkDPudvu3MH4BvmI_75L7D5JgU94E9x3cvzWuNgXBijl.8P_J8ZBlYEi.GWSPEf9jQs
 A2_RxvV77YZBb.erEoHwL1Mbx9Pm9zqKqpoK6xAm1DuaeBFIy.DLP6qzOa9w3vzIy31Ds9SHMMA7
 GBsJ6SR5UU8If8oUCJMBk0ki64TTWLBKNOJ5U9NhceiP8jUzyrgk_uh2vnmAsDqiHLXvcUY8.Wa5
 3h4MsTQo260cuEVWufFjzaxdX5qPGdOwJgpWQ0Wc6n5KJAIw56wjqehdtI6wnMYS4UWl8OJSCHrc
 UDk0vnTGG4k2cDbHAG1.Bh5rjmHqk3HJRYKDPw9.mx_6ABlswZzn2znYEv7a4xv944fjJm4cUhKi
 ocAFlH5U_di5nhtcPGQe2NVtib2Y3f4xH3uOb_uX4AiLhUc9tJL5NBgh1mrG3sJnuyJ6655yJpUb
 PkzVW429BlWGtJx_Dc1yxZUnxdoq3o84yQFTavMQ21KLOGvN_RfTwS0h7BYqSTZ95ThgeGNl3Q_1
 BLRFns_qRlRCKiWDKDbnN.yJIZ575MhwuP5l6EnYsyVTVoHUE3IMwcJEyO.QVM7Yg8WZUz.zo7D8
 1rCwbBG.sLA0wZ4GuCEDGdMEC9e4ocYufpbP5yp_I20lXjRgdlW.VrOEuXMn8b.W0d.9dWCMVdPl
 kavUIwBLr2nvZSVkBSbWXl3xbhAaBsLXwsFI5L9xGMy2w_s7hQjSfMuK2WxBBLi8GL8C3OCZUY8w
 X8UQWEj4BgNl9e62ziLZk59RwvrOURkmSmSHsy2VpOpsiVFd.zDuZ1SdekzIbt4F6ZhIwc0TS0Kn
 PGcjElTpyh_Pw1fPek0YKTzQNfoV8VizGTpy_GVib7Xobq4TjHpngxDA2MmwhNwYVq6o0LfGV.70
 W961xFBRY1j0ewMZ1Z0kJUNoBLcOvsCDMv1ElMaXcsEoB892wdLo8HCVZLFQEu_w6oFZ5NUgMppe
 18D9s50kRjga1zaUiU3_xuhDevUESm3YqRHI0s7v0sgRzPZWtS6oFZUwiZYZe11.RWIlpr6W2dkt
 vDh0.nxPxcPujPdM40.7eigiNiv4zExw.pck4Jvw_c9Kzl6QlbJgzh_01nDbd_SGa_ONOrg2YQnH
 sM25moKwaTbCsBy6d35R_4T.vqvif7kF9284EymcRaMJ47hOs65bQ.oWBlmIa6W5koUlr1IW4uxL
 TSkTKv0rmWAwjxGbT5p6fP7DSjIM5uG0Sk2OFyEDSDEAeMrUoIWmH2UEED.4tEM4.MvbKT6bRl7V
 j7oBZjz9zbe3Iv3BWkaUNQ20R4qhgUIZlQOQ-
Received: from sonic.gate.mail.ne1.yahoo.com by sonic301.consmr.mail.ne1.yahoo.com with HTTP; Fri, 1 May 2020 11:25:36 +0000
Date:   Fri, 1 May 2020 11:25:33 +0000 (UTC)
From:   "Mr.Sani Ali" <mrsania588@gmail.com>
Reply-To: ubaatmdepartmentbf@gmail.com
Message-ID: <1614728530.312541.1588332333123@mail.yahoo.com>
Subject: Goodnews for you.Recieve your 'ATM CARD'urgently
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <1614728530.312541.1588332333123.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.15820 YMailNodin Mozilla/5.0 (Windows NT 6.1; ) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/81.0.4044.129 Safari/537.36
To:     unlisted-recipients:; (no To-header on input)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



Hello Old Friend,

How are you doing? Hope you haven't forgotten me; I am Mr.Sani Ali, former manager in a well respected bank of Africa, Burkina Faso in west Africa, who contacted you some time ago to assist me in a business. Though, you weren't able to assist me up to the conclusion stage in that transaction by then is very much happy to inform you about my success in getting the fund moved to Iran under the assistance, and co-operation of a new partner from Iran. Presently, I am in Germany for investment projects with my share of the total sum.

Meanwhile, I didn't forget your past efforts, and attempts to assist me on the moving of the fund, and I makes sure that you aren't left behind or out from the benefits of the transaction. Hence have kept aside for you the total sum of: $4 75,000 (four hundred, and seventy-five thousand, Us-dollars) in the United Bank for Africa ATM department. I have compensated you with that above said amount for all your past efforts, and attempt to assist me in that past successful matters. I have appreciated your kind efforts at that time very much, so feel very free to contact Mrs. Sharon Mohy, via with below email address the bank ATM department manager for sending of your ATM credit card that contained the above sum in your name.

And make sure that you instructed her on how to send the deposited ' ATM CARD ' to you and please do let me know immediately you receive the ' ATM CARD' so that we can share the joy together after all the stress at those past times ago. At the moment, am very busy over here in Germany because of the investment projects of which my partner and I are having at hands presently, and finally remember that i had left an instruction to the ATM department manager Mrs. Sharon Mohy.

Therefore, as soonest as you contacts her for the said 'ATM CARD' to be released and sent to you, she will surely send the 'ATM CARD' to you. Below is the contact of the ATM Department of the bank, Burkina Faso. West Africa.

Contact person:-

Mrs. Sharon Mohy.
United Bank for Africa ATM Department,
Ouagadougou, Burkina Faso. West Africa.
Email Address: (ubaatmdepartmentbf@gmail.com)

Tanks from
Mr.Sani Ali
