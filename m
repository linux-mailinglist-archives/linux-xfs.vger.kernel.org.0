Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 613E6DDD48
	for <lists+linux-xfs@lfdr.de>; Sun, 20 Oct 2019 10:21:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726027AbfJTIVs (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 20 Oct 2019 04:21:48 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:45826 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725893AbfJTIVs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 20 Oct 2019 04:21:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=PBcmmJkcV4IwKVNxSrVsm8IEeYs8sxbb1XreUEFT0No=; b=kHpqWDuptNh10Fky//NjE/SHF
        iXSMgz6IdXQMs9ri5Y+jAYFDBq82o97culqi7x33Sj/ajXjRTc49XjmiZELeNSXpTAVXv22w6atg/
        +oFRkP3sXkZP6vr5EuT4/+LHZijzdAbjNScZsfsJWXJsFYIfma4mkYkLL5h3G/ZWNwLGzLd4zFxs3
        ugOsUBX0xoSSN/MiupC4epKqGtpHif3u+oP1yFYwacx+QKrTudbHHBXzhRyJvchBj8uezE4/eAAZ4
        TgWrOmLAuE3g11nY3POKXydvMJ5bKmNjjD5dWay8MRt3FNZe+JuaoUXpxvYeZJ//dqLMmFNZctrVg
        9poKcHrcQ==;
Received: from [2001:4bb8:18c:d7b:c70:4a89:bc61:3] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iM6TD-0004ci-L2
        for linux-xfs@vger.kernel.org; Sun, 20 Oct 2019 08:21:48 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: xfs inode structure cleanups
Date:   Sun, 20 Oct 2019 10:21:41 +0200
Message-Id: <20191020082145.32515-1-hch@lst.de>
X-Mailer: git-send-email 2.20.1
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
