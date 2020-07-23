Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62A6622A72C
	for <lists+linux-xfs@lfdr.de>; Thu, 23 Jul 2020 08:09:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725843AbgGWGJK (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 23 Jul 2020 02:09:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725773AbgGWGJK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Jul 2020 02:09:10 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C008DC0619DC
        for <linux-xfs@vger.kernel.org>; Wed, 22 Jul 2020 23:09:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ecwv5/One/VldiP8rAJrX66p0u3GjFAAFsRbiuNZf+c=; b=SZaQ+UzwN5YXVN+pJBykjKNdZ1
        p5cAguDtI5tMURdKKb/+E53HCLW3Qv9cbMroWswE22ltWl8rD7E0GxxDfb1ZgTx9/MIcavSakrmki
        tLP1ZWj/hFjc76QMWk99JzEyHrmUXUL2O0dsAQCXX91WX6Pffvg851N8i34WzHrKZcDeYH73Y+5wu
        6ml4fhUE5Mn12r1dN1UDs22nahcjQti7Eb11zjKHgxvVDBHxKkPHbmuiGWxr2oZVugBkuxLwMot1Q
        vI4YTDZqCAWtfw0/1rRyWTmeXhe4608jRAPm0pgCXPXxGndFDK+5nvBTrGWDrAc3EvSP/QmG7ZMF4
        cRY4jyew==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jyUPS-0003i4-OH; Thu, 23 Jul 2020 06:08:50 +0000
Date:   Thu, 23 Jul 2020 07:08:50 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Xiao Yang <yangx.jy@cn.fujitsu.com>
Cc:     sandeen@sandeen.net, darrick.wong@oracle.com,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH] io/attr.c: Disallow specifying both -D and -R options
 for chattr command
Message-ID: <20200723060850.GA14199@infradead.org>
References: <20200723052723.30063-1-yangx.jy@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200723052723.30063-1-yangx.jy@cn.fujitsu.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 23, 2020 at 01:27:23PM +0800, Xiao Yang wrote:
> -D and -R options are mutually exclusive actually but chattr command
> doesn't check it so that always applies -D option when both of them
> are specified.  For example:

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
