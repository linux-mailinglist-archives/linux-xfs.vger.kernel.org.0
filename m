Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7375D202215
	for <lists+linux-xfs@lfdr.de>; Sat, 20 Jun 2020 09:11:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726874AbgFTHLL (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sat, 20 Jun 2020 03:11:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725977AbgFTHLL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 20 Jun 2020 03:11:11 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B052C0613EE
        for <linux-xfs@vger.kernel.org>; Sat, 20 Jun 2020 00:11:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=gMUvEO2N6cZeJHm1QPsy0EDYtx4mS972kJ9MP6VH+Wg=; b=Slp6AP/RofwLBb/UzKgvMHRr6T
        d9FbTI8wPEHRUb/cT8/9wPUCOZqCGqylrG1akhhZTjjTcZ8a8GUED5tDe6LVCbFTSBwSo/WLMjUJ/
        M27BYEp3P1KlE7LhDYSl2fXnXrQGU0GpxIVzOzgxw3YG9Ey03Q2IHe25utS4MrY9noLG0CebNHTDa
        Oxc6VCZHvK51oFvjXu6xbRi9NxBHZcHydSdlsWDs0gCs286sxzLgMIMbLq8HCBJHDArDLcofr63Bo
        fW22N3U/WN0rIY7JcEz4tjnXrO7J9bil1S2eDM65AlmiWa/2nXqTIMhFJKmVriPVL2z4jXog3o0Xb
        az+WSOQQ==;
Received: from 195-192-102-148.dyn.cablelink.at ([195.192.102.148] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jmXeb-0000ww-DA
        for linux-xfs@vger.kernel.org; Sat, 20 Jun 2020 07:11:05 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: xfs inode structure cleanups v2
Date:   Sat, 20 Jun 2020 09:10:47 +0200
Message-Id: <20200620071102.462554-1-hch@lst.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This series cleans up how we define struct xfs_inode.  Most importantly
it removes the pointles xfs_icdinode sub-structure.

Changes since v1:
 - rebased to 5.8-rc
 - use xfs_extlen_t fo i_cowextsize
 - cleanup xfs_fill_fsxattr
