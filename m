Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1436E347A89
	for <lists+linux-xfs@lfdr.de>; Wed, 24 Mar 2021 15:22:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236240AbhCXOWG (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 24 Mar 2021 10:22:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236173AbhCXOVj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Mar 2021 10:21:39 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4696C061763
        for <linux-xfs@vger.kernel.org>; Wed, 24 Mar 2021 07:21:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=1Q4kNI7FrKmi1WZUJp+4NlPNjPwZkJr1muVG3LvVV58=; b=R/vTV+yA/k8n7qm8ReINmcA1ha
        pw1KAz3NYuax+0UUY+tfgqhxV9R0Xih40rhoCP3/SAJ75X8rtydDPSFuVQ8WB5gjDdP8He7CulFqK
        4hPGvJz0E7YY5dhYpLBnDWdi7/a3X17hXv9AVIwXhhdCtHstjUozi4uSSW9Tz1fLef4h64sbGt4JP
        VCRiNMb2Ov+QmQ1X/RH1bWE2bM0p3JNAhTJk3Cf5a1B3n24H3TAV1JUPb0jLCe3rFBnvwVCoC+miE
        EyRfeGC+agzZmSep0JByNjAuLkvfSjb9BQf8tjtMYiYlIUg166IgvzdSu4LoUSM7E8kN6lkYn+Kx2
        fywwQyjw==;
Received: from [2001:4bb8:191:f692:b499:58dc:411a:54d1] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lP4O3-0045WN-UP
        for linux-xfs@vger.kernel.org; Wed, 24 Mar 2021 14:21:32 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: xfs inode structure cleanups v3
Date:   Wed, 24 Mar 2021 15:21:11 +0100
Message-Id: <20210324142129.1011766-1-hch@lst.de>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This series cleans up how we define struct xfs_inode.  Most importantly
it removes the pointles xfs_icdinode sub-structure.

Changes since v2:
 - rebased to 5.12-rc
 - remove the legacy DMAPI fields entirely
 - ensure freshly allocated inodes have diflags2 cleared

Changes since v1:
 - rebased to 5.8-rc
 - use xfs_extlen_t fo i_cowextsize
 - cleanup xfs_fill_fsxattr
