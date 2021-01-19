Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC9D92FB29B
	for <lists+linux-xfs@lfdr.de>; Tue, 19 Jan 2021 08:15:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729934AbhASHN2 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 19 Jan 2021 02:13:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729495AbhASHNR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Jan 2021 02:13:17 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37494C061574
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jan 2021 23:12:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=l+283mN8745iaj2VEgYIf5yzNl
        gztGKgdDkG3hlAWMAxD8pmO45+d3Q/XZAgdXWxwn3B3ebqczkS0bWBEfMTUyVjE08auWYF0fnvNDN
        zWJUy6wf0Je9ydJwv1QxE7uCkSkon5wIzFXm1Uui3ztKt1IKQjAIQNYoqomdiCYD2Z66V63ZyNja1
        4ej6QwWvbBn8nCQtDy1mtie5Pn2LsiK1bwlICcvlxWai+OREwBIFikeNg+aSdstp5bOvtF3uQhoFb
        IEn8X0zj1kA249+oe7F8tPMD85Z0eWp1Ixq5KYlLuXBHXjWPyt+VqNUhUEoWeaevORGqXv8ICB7wR
        TnmkFB0w==;
Received: from [2001:4bb8:188:1954:b440:557a:2a9e:a981] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1l1lBl-00Dwga-KT; Tue, 19 Jan 2021 07:12:32 +0000
Date:   Tue, 19 Jan 2021 08:12:28 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/10] xfs: relocate the eofb/cowb workqueue functions
Message-ID: <YAaGXCEw82n6FKWB@infradead.org>
References: <161100798100.90204.7839064495063223590.stgit@magnolia>
 <161100798676.90204.16460265222758873473.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161100798676.90204.16460265222758873473.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
