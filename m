Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3AD3019AEAA
	for <lists+linux-xfs@lfdr.de>; Wed,  1 Apr 2020 17:25:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732756AbgDAPZ2 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 1 Apr 2020 11:25:28 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:33774 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732504AbgDAPZ2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Apr 2020 11:25:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=4BS8ivTCYFspki1TbBqRnlzcyvC7A7pG5kcAWU25CRM=; b=QIe0p59LYWgpBVUCjU4DFDQkod
        XtoWdCHWIOL8HHvfCQ+03y9wErs5qHWwK7NyQcmccuUl7dxJMzgUvYpA3PZ3f5IRBpMjNfySksqI4
        MP9ctDsrZ6yy1ouKzoIUtQvBdfoWmEdI9qiuGL5rlg50Ba7TFiesoRxBXwOnFJmvYOwyuyVotKGSu
        sv/yBEAsISEax8IZq3d7e+u0zGVmCc7MLEYZb5Kgmt1aXAy8T3ENFoEyrx1+PZ42QPyqwMQprJBP5
        sbaECNcA8h6GsKgWDqHevbwSDiW39VPjoA9kOOK1UHa8CRJ9zWsqsDWJPRI2NbcgANXiRjRlvQxAN
        IuBtTvtg==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jJfF9-0005Pa-Tq; Wed, 01 Apr 2020 15:25:27 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     hch@infradead.org
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        linux-xfs@vger.kernel.org
Subject: [RFC 0/2] Begin switching iomap from apply to iter
Date:   Wed,  1 Apr 2020 08:25:20 -0700
Message-Id: <20200401152522.20737-1-willy@infradead.org>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

I don't like the 'apply' design pattern.  It splits the logic between
two functions, and from a performance point of view, it introduces an
indirect function call which is more expensive due to Spectre.  This rfc
only converts one function over to use the new API as a demonstration.
I don't want to waste time on it if people aren't interested in this
approach.

I haven't tested this at all; it's probably buggy.

Matthew Wilcox (Oracle) (2):
  iomap: Add iomap_iter API
  iomap: Convert page_mkwrite to iter API

 fs/iomap/Makefile      |  2 +-
 fs/iomap/buffered-io.c | 51 ++++++++++----------------
 fs/iomap/iter.c        | 81 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/iomap.h  | 24 +++++++++++++
 4 files changed, 125 insertions(+), 33 deletions(-)
 create mode 100644 fs/iomap/iter.c

-- 
2.25.1

