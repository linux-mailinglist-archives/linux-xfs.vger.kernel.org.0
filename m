Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B06B77D408
	for <lists+linux-xfs@lfdr.de>; Tue, 15 Aug 2023 22:20:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233197AbjHOUUR (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 15 Aug 2023 16:20:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236136AbjHOUT4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Aug 2023 16:19:56 -0400
Received: from muffat.debian.org (muffat.debian.org [IPv6:2607:f8f0:614:1::1274:33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABAA11BE7
        for <linux-xfs@vger.kernel.org>; Tue, 15 Aug 2023 13:19:55 -0700 (PDT)
Received: from usper.debian.org ([2603:400a:ffff:bb8::801f:45]:45756)
        from C=NA,ST=NA,L=Ankh Morpork,O=Debian SMTP,OU=Debian SMTP CA,CN=usper.debian.org,EMAIL=hostmaster@usper.debian.org (verified)
        by muffat.debian.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94.2)
        (envelope-from <ftpmaster@ftp-master.debian.org>)
        id 1qW0WC-004dgd-2l
        for linux-xfs@vger.kernel.org; Tue, 15 Aug 2023 20:19:54 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=ftp-master.debian.org; s=smtpauto.usper; h=Message-Id:Date:Subject:From:To:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=hlYmpZAMhOyFvGHRHei4LGLaexl9EZPDUeeuzNZWeJI=; b=KPkVgO9E8Wo7Gl69Kd4cHd/u10
        2gZaCWO3wA6LibCajeyJOvjIiEcREjVde4Q81kj8W8kVyIu/s+aAEgyAQAQ5MDFG3ZelH7iTbV0hm
        ZCv/YbpppBVoRUrzPykd2c9vlbdAvns+O9ivt6qBJ0anXbKStd33fDsSm0tk38B/y5EJz/DfcCmms
        u963r1JapQxA6OgDW03NEM8iriKRSdItTyu1aTNeXQTxsivcPaenvl/WjFIXHkSBKFbnHjkRbfIEb
        REsmkFv3fpouTTRATMDdW41BNGa4Aq/ghFIyAMKssADqjkBLvG9uNpKaIS4RnfpLaVKo2wS4aZAPa
        GuBY+XsA==;
Received: from dak-unpriv by usper.debian.org with local (Exim 4.94.2)
        (envelope-from <ftpmaster@ftp-master.debian.org>)
        id 1qW0W8-004UgL-I9
        for linux-xfs@vger.kernel.org; Tue, 15 Aug 2023 20:19:52 +0000
To:     linux-xfs@vger.kernel.org
From:   Debian FTP Masters <ftpmaster@ftp-master.debian.org>
Subject: Processing of xfsprogs_6.4.0-1_source.changes
Date:   Tue, 15 Aug 2023 20:19:52 +0000
X-Debian: DAK
X-DAK:  DAK
Auto-Submitted: auto-generated
X-Debian-Package: xfsprogs
Message-Id: <E1qW0W8-004UgL-I9@usper.debian.org>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

xfsprogs_6.4.0-1_source.changes uploaded successfully to localhost
along with the files:
  xfsprogs_6.4.0-1.dsc
  xfsprogs_6.4.0.orig.tar.xz
  xfsprogs_6.4.0-1.debian.tar.xz
  xfsprogs_6.4.0-1_source.buildinfo

Greetings,

	Your Debian queue daemon (running on host usper.debian.org)
