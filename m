Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B02FB72DD24
	for <lists+linux-xfs@lfdr.de>; Tue, 13 Jun 2023 10:59:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237163AbjFMI7c (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 13 Jun 2023 04:59:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234253AbjFMI7b (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Jun 2023 04:59:31 -0400
Received: from mitropoulos.debian.org (mitropoulos.debian.org [IPv6:2001:648:2ffc:deb:216:61ff:fe9d:958d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81CB3AA
        for <linux-xfs@vger.kernel.org>; Tue, 13 Jun 2023 01:59:30 -0700 (PDT)
Received: from usper.debian.org ([2603:400a:ffff:bb8::801f:45]:58668)
        from C=NA,ST=NA,L=Ankh Morpork,O=Debian SMTP,OU=Debian SMTP CA,CN=usper.debian.org,EMAIL=hostmaster@usper.debian.org (verified)
        by mitropoulos.debian.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94.2)
        (envelope-from <ftpmaster@ftp-master.debian.org>)
        id 1q8zs1-00DLqh-6b
        for linux-xfs@vger.kernel.org; Tue, 13 Jun 2023 08:59:21 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=ftp-master.debian.org; s=smtpauto.usper; h=Message-Id:Date:Subject:From:To:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=IeCD2/nP16g4ryoixWPY3URn2AxToUZ1N5TG7LpTkE0=; b=rTY+0G97reBSISqcfb7SQSl86/
        sSskZVfFI4LpXs1VNuF1tq2HWvCC5mia2/AGSJRFaX6KYDlxfZdiOGF1zxa9iyBV+LfauMuhSC3z0
        YRWlGm43QUhMCctHxbUKXGzv4YN8t08mx0+PHQz+bqBda0Z99E/JcTfToVuzBWsk9WYDYZTedmk6A
        nC8AsFQsbSHUMdKBP1LnCwxry/jThx7g0WiI1qcpF2TdZmYFFmCCYsYtkTXHAxN20HNOAvdyew0Ag
        dNhF8jM7rJ3PVqR25udSX1+/KJ0VL8ddgzHKdTEWn0yk+s3OjjeE/8BAjMkYi3nLiwzzUXntvhBEv
        GBtOQyTA==;
Received: from dak-unpriv by usper.debian.org with local (Exim 4.94.2)
        (envelope-from <ftpmaster@ftp-master.debian.org>)
        id 1q8zrz-00BhwM-Jb
        for linux-xfs@vger.kernel.org; Tue, 13 Jun 2023 08:59:19 +0000
To:     linux-xfs@vger.kernel.org
From:   Debian FTP Masters <ftpmaster@ftp-master.debian.org>
Subject: Processing of xfsprogs_6.3.0-1_source.changes
Date:   Tue, 13 Jun 2023 08:59:19 +0000
X-Debian: DAK
X-DAK:  DAK
Auto-Submitted: auto-generated
X-Debian-Package: xfsprogs
Message-Id: <E1q8zrz-00BhwM-Jb@usper.debian.org>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

xfsprogs_6.3.0-1_source.changes uploaded successfully to localhost
along with the files:
  xfsprogs_6.3.0-1.dsc
  xfsprogs_6.3.0.orig.tar.xz
  xfsprogs_6.3.0-1.debian.tar.xz
  xfsprogs_6.3.0-1_source.buildinfo

Greetings,

	Your Debian queue daemon (running on host usper.debian.org)
