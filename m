Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DD457DC26
	for <lists+linux-xfs@lfdr.de>; Thu,  1 Aug 2019 15:06:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726422AbfHANGm (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 1 Aug 2019 09:06:42 -0400
Received: from sonic311-30.consmr.mail.ir2.yahoo.com ([77.238.176.162]:33765
        "EHLO sonic311-30.consmr.mail.ir2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726407AbfHANGm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Aug 2019 09:06:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.pt; s=s2048; t=1564664800; bh=HgpSDDBQZxhrC8eCz1CdrGLN0guU8rUYqRopEoi8p6Q=; h=Date:From:Reply-To:Subject:From:Subject; b=q+Tp/4JK7l1ecXCn0iYMuXxhOAnZ4b2pMHrbQL8ewVylSOtv35gLACizLqllLBktuHddzX2ioOEyH6TK4uVK77nWp8ohyZ0vaLgyF7tq/wFnFcJABmsJhR3fVAWORlvCgwUnnl+07NlfpNdAlmVbs0HYVjrCbLmfvxGqzxpP3mww1X9gvaT1mhbUW8+aeIz0pmVwmRFn0ycD2IYi8FfUcO9+DAJzulxY8XmSd7py0DQcjWthdGZ+aXe/NiTL29u76Vb79IqgBfxX78htgsvgcF2ujfuPyC0pPSHhmRPfvyr3YFQg4Wj7rqv0oCa78xHr44eHvHGRRW25ueT17zyH9Q==
X-YMail-OSG: zlvGRnAVM1mSemoGtgRskiYwbushaPzlirnkWd.m_OrWbRjsQq2nuO12UoqgmDs
 EGtxgkPX9xlIEfQ9kzTZWdwVpan5nSxOem_DTyhRiDCGvHJ5eGVUDimPlotjGUFyP2rwYzZGeVlE
 0imjfXU8cNNQBty.3wgOn0xfvR4u86lii9vCqKwsDibAIXZP9OJS3T_AdwQRJZ0irmp.3SV0.deO
 Jts7S8aXP4SL4B1camJXw_UueYvZJHA3myq69adsPkdXU.WexFJWTKclK29yOLp7h_bYZeCb9d41
 L1X.SJ4sqqsjqu2o2WKjaDS87uC18ga914TgoMsky0QUF7E4XnHYr1JteQ5bLzIt8I2ZaPyTG_Id
 XA5nbJPUUyhmd4vYaPMv.RYIjXwmc_pZVA8GFzLyO4Tjtu.5k52jbpmkNDQPF1lM3.gmQyLU5gLY
 WADIRJ2fc8nexORxusvrI.xuXLK1aQN81fxGBOTquC6GoBT2wNriMFOzn_BDk6vSdKka3RGAdE3u
 25rmIu3EoY3WhqmT.3A0Fmg86e861GRTzNBw0yLzy7gUOCEARDSuK_RMpqYgb3CGxTcqjXn3CC_q
 ChI.cZtR1EjVlaD01uG.xNJf_C1jElvkxYXYmFqk6e5JXy_veAK_vn4xNNa09wZ0lXIIXHBVchdg
 A5RnNy6nAb8f8G3ItbDbVg3xP_4wqOtp7iMKsvRm4KobHe0_VXBjW2WdZcHt8bg32x6wWnIzkAUl
 JuYGO9mkTELyPUcWIGQF5Vovv2B.GngNw.wIqVgnYSnoHE5oQ1OR5.4UekHHjILJiaJ6pbqkdO8h
 fTKAr1aAcwu5vZrnftNY8HOiDmu5xMpdn2S8rR4_llfgEMOxusD97rdTmvbBiqEvz1_m4qVj.lnV
 rHJ1osh0qtLOfKskoQljsmr4gQHm8b3iqpSvSX14t0bladEzgQW4vVHtFFQ35i9Kyce_D4BvYL3x
 TWS85zkTiVewzShBpKS7AcqqwCyJtznLM4FCQNHOuPC7pUrounF1itcVtu4q6CK4bEvaR0DzESfT
 XCYy5_uBmscE1SjnyImykq0fsGKNjfwrpnDKFvvjd0nPgg6beRiqMmHFiy75u6F5dSDTEH_RB3Tc
 95pUrUYNTOz4sKQrbQ3wiAeOP40y6QJTReDhHrn223WqGTQ9L0Ped4pZlxtfX6S8oz059zIS1VOI
 egYA4c5Ajwhu19tZXnUvjTOegt6im8hnTnd1SIT5p55I8x2VCDeTezpisNixGcWyAbTk-
Received: from sonic.gate.mail.ne1.yahoo.com by sonic311.consmr.mail.ir2.yahoo.com with HTTP; Thu, 1 Aug 2019 13:06:40 +0000
Date:   Thu, 1 Aug 2019 13:06:38 +0000 (UTC)
From:   "MR. UMAR YAR ADUA." <junmrs.meifen70@yahoo.pt>
Reply-To: umaryaradua101@aol.com
Message-ID: <1214376591.4869673.1564664798205@mail.yahoo.com>
Subject: Attention dear sir madam
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To:     unlisted-recipients:; (no To-header on input)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



Dear Sir,


MY NAME IS MR. UMAR YAR ADUA A CITIZEN OF NIGERIA NORTHERN PART I AM INTERESTED TO

INVEST IN YOUR COUNTRY WITH THE SUM OF $12.5million AND THE MONEY BELONGS TO MY

LATE FATHER YAR ADUA.

HERE IN NIGERIA THE ECONOMY IS NOT ENCOURAGING HOWEVER I WILL LIKE YOU TELL ME HOW

IS YOUR COUNTRY ECONOMY AND WHAT CAN WE INVEST THIS MONEY ON IN YOUR COUNTRY.

FURTHERMORE THIS FUNDS WILL BE SPLIT, 20% WILL BE PUT OUT FROM THE TOTAL FUNDS FOR

ANY EXPENSES THAT COMES IN LOCAL OR INTERNATIONAL WHILE 50% OF THE FUNDS SHALL BE

USED FOR INVESTMENT THEN 20% FOR YOU THE REMAINING 10% WILL BE KEPT FOR ME UNTIL I

ARRIVE AT YOUR COUNTRY IF YOU ARE INTERESTED GET BACK TO ME THROUGH THIS EMAIL.

=========

BEST REGARDS,

MR. UMAR YAR ADUA.
