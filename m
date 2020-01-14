Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07C5F13A2B3
	for <lists+linux-xfs@lfdr.de>; Tue, 14 Jan 2020 09:16:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726452AbgANIQJ (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 14 Jan 2020 03:16:09 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:42270 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725820AbgANIQJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Jan 2020 03:16:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=L/Xe87jqdqMf5/RDvb4Qb2HtJvVpwW+OaFsluXAcqJg=; b=MC4JJtt8qe8z5tYtMDHWiTd9xX
        b3sHB3xVNz0zxXlxBZNtG5J3w5OMIwa1hR0LiNGWzF6S0EVaqL/bsR4OlnXFo1HC7wiJPJX+5jnYj
        Vwi8JtQXjz7WsAf1jJYT7tUcgTlMZXwRYkKILJWAmIDy4QOKjzQyseRiA6G15gJswsr7/q9eVXVNE
        JsnP3ohqj5vwH+4QK2y9zXVjSHEM8QVC5pv4F77Kpp7iCc2ctURBJtYv68Q+Rx2oWEZoRPHAFB96T
        Vh2PLpxjos1UG0ZnxflRTflfBxwzu22gmbwP6dHWT9JwEuLld2ON4hybB8y7YbG9nWoi9gy2D2+Am
        koms9Qzg==;
Received: from [2001:4bb8:18c:4f54:fcbb:a92b:61e1:719] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1irHMu-000733-K0; Tue, 14 Jan 2020 08:16:09 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Allison Collins <allison.henderson@oracle.com>
Subject: [PATCH 18/29] xfs: remove the unused ATTR_ENTRY macro
Date:   Tue, 14 Jan 2020 09:10:40 +0100
Message-Id: <20200114081051.297488-19-hch@lst.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200114081051.297488-1-hch@lst.de>
References: <20200114081051.297488-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_attr.h | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index 0c8f7c7a6b65..31c0ffde4f59 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -69,14 +69,6 @@ typedef struct attrlist_ent {	/* data from attr_list() */
 	char	a_name[1];	/* attr name (NULL terminated) */
 } attrlist_ent_t;
 
-/*
- * Given a pointer to the (char*) buffer containing the attr_list() result,
- * and an index, return a pointer to the indicated attribute in the buffer.
- */
-#define	ATTR_ENTRY(buffer, index)		\
-	((attrlist_ent_t *)			\
-	 &((char *)buffer)[ ((attrlist_t *)(buffer))->al_offset[index] ])
-
 /*
  * Kernel-internal version of the attrlist cursor.
  */
-- 
2.24.1

