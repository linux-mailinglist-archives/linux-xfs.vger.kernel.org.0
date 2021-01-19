Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5813A2FB2C3
	for <lists+linux-xfs@lfdr.de>; Tue, 19 Jan 2021 08:19:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727430AbhASHTT (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 19 Jan 2021 02:19:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727223AbhASHSo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Jan 2021 02:18:44 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DBEAC061757
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jan 2021 23:17:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=ILd11fFyEut9nsd7yg6ABX7mOF
        +Oy7TM2nM7WWsQB2kMaD0De9oxVXeMxDtwujLUUaoZdo894n+kCSuy3RAKvQqgXCmn7OlIPevl1iX
        ekJo8Vfqx1LAdxiLD1wbXwnghw/mxDeQz6W2bSuYASKBBJ838QNHnKzftq6aszUBMsOAoAqj0+AEE
        YNrV2SfiuTqcyNasf9B3HqOUVJT+fFiibyH9sCTNWXWgxuLrTiv/bDTwYtascXBaq/y7FMNRGVfmq
        lgIfWwta/7Kae2hLqxdmPUl4WVju8mb05JZfGKczHOFiNUposBIkexHJ8U3TF4ZGX7EmPmyAnjJJi
        5Vv9CQUQ==;
Received: from [2001:4bb8:188:1954:b440:557a:2a9e:a981] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1l1lGJ-00Dx8s-0k; Tue, 19 Jan 2021 07:17:22 +0000
Date:   Tue, 19 Jan 2021 08:17:10 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/10] xfs: consolidate the eofblocks and cowblocks
 workers
Message-ID: <YAaHdgV4R5Dr2QHj@infradead.org>
References: <161100798100.90204.7839064495063223590.stgit@magnolia>
 <161100801985.90204.3010648139775304166.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161100801985.90204.3010648139775304166.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
