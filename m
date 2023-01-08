Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5E6B661453
	for <lists+linux-xfs@lfdr.de>; Sun,  8 Jan 2023 10:38:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230390AbjAHJie (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 8 Jan 2023 04:38:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbjAHJid (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 8 Jan 2023 04:38:33 -0500
Received: from muffat.debian.org (muffat.debian.org [IPv6:2607:f8f0:614:1::1274:33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F17713E0C
        for <linux-xfs@vger.kernel.org>; Sun,  8 Jan 2023 01:38:32 -0800 (PST)
Received: from usper.debian.org ([2603:400a:ffff:bb8::801f:45]:55440)
        from C=NA,ST=NA,L=Ankh Morpork,O=Debian SMTP,OU=Debian SMTP CA,CN=usper.debian.org,EMAIL=hostmaster@usper.debian.org (verified)
        by muffat.debian.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94.2)
        (envelope-from <ftpmaster@ftp-master.debian.org>)
        id 1pES8N-006MKJ-P1
        for linux-xfs@vger.kernel.org; Sun, 08 Jan 2023 09:38:32 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=ftp-master.debian.org; s=smtpauto.usper; h=Message-Id:Date:Subject:From:To:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=yO15VS/cyvmO7YyCbbBiL9Tqo00Fb8rDslZ4OM9K9XE=; b=Y0K169lwIyS6YmgSIYgTMbs2wB
        TABnNzbjz1tWbx2RMA8zHyfP54fDl2GZbhMYkR4/xOUOAzf5K3viwYLOZRrI+atGOJsNuzSaTMZ0V
        69ERJGY4jZSa8CK0XpeIySyb3XQRcue0dR6aaWCCr8lwMV6ZNAgWT9mRaqzCVJHTLoBdBNo+LvUsU
        oOR2qpxxWdUDPCkx2JiPOc5UzrVB2wBfaJERzxt/vnSwpAhy9kuYeknPzBTMRRHBDSj6y8cz356t4
        9Wr2+1nhGc8jUIbiisSbVyqePLh6/ZpfKipXPkCcHXN49B6tN5oImBVgoD8z5SMfqD2Mf9U4Hg6Qr
        uHNZS1Sw==;
Received: from dak-unpriv by usper.debian.org with local (Exim 4.94.2)
        (envelope-from <ftpmaster@ftp-master.debian.org>)
        id 1pES8M-009MT1-C9
        for linux-xfs@vger.kernel.org; Sun, 08 Jan 2023 09:38:30 +0000
To:     linux-xfs@vger.kernel.org
From:   Debian FTP Masters <ftpmaster@ftp-master.debian.org>
Subject: Processing of xfsprogs_6.1.0-1_source.changes
Date:   Sun, 08 Jan 2023 09:38:30 +0000
X-Debian: DAK
X-DAK:  DAK
Auto-Submitted: auto-generated
X-Debian-Package: xfsprogs
Message-Id: <E1pES8M-009MT1-C9@usper.debian.org>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

xfsprogs_6.1.0-1_source.changes uploaded successfully to localhost
along with the files:
  xfsprogs_6.1.0-1.dsc
  xfsprogs_6.1.0.orig.tar.xz
  xfsprogs_6.1.0-1.debian.tar.xz
  xfsprogs_6.1.0-1_source.buildinfo

Greetings,

	Your Debian queue daemon (running on host usper.debian.org)
