Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54A7423CFA
	for <lists+linux-xfs@lfdr.de>; Mon, 20 May 2019 18:14:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389278AbfETQOm (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 20 May 2019 12:14:42 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:34986 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387964AbfETQOm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 May 2019 12:14:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=BYZ2kuTc+X/Wq1R6dabbUDytI9b508awc1c+soGtIcE=; b=EVdaLSaz0BK5ct71Y2tDZVfar
        t3QgDfGhntgtqRnqt/08vYvVmJEVp62Io7TNUgD12/UAI+JsD33EllRpdxmfOMMuzeYorBYua9IaQ
        GUL45jChN9mxz7R4AkkvR6IpODv5hbtqQsUtcmyMJVFQ0RGQyttaEYKVCPwK5pUDIzneo8xXZ/qOz
        w7JiyQ+8xjmS2J1TU2jsMqVqhZXWxgpit94omZtLcs8+DDFivXkXwlxiiKyn5jtILnb3jh7NnGRWf
        ihY17+I/GH5GSTC4M3ba6Xb05xqNapYAlhSfS8eFvIMm2R56ymafvg9sm1ARi3j9MSPzj5L56fHsq
        tmCVvOQGw==;
Received: from 089144206147.atnat0015.highway.bob.at ([89.144.206.147] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hSkvw-0005G8-DZ
        for linux-xfs@vger.kernel.org; Mon, 20 May 2019 16:14:40 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: use bios directly in the log code
Date:   Mon, 20 May 2019 18:13:30 +0200
Message-Id: <20190520161347.3044-1-hch@lst.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

this series switches the log writing and log recovery code to use bios
directly, and remove various special cases from the buffer cache code.
Note that I have developed it on top of the previous series of log item
related cleanups, so if you don't have that applied there is a small
conflict.  To make life easier I have pushed out a git branche here:

    git://git.infradead.org/users/hch/xfs.git xfs-log-bio

Gitweb:

    http://git.infradead.org/users/hch/xfs.git/shortlog/refs/heads/xfs-log-bio
