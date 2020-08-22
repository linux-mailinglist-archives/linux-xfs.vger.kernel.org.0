Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED1D524E609
	for <lists+linux-xfs@lfdr.de>; Sat, 22 Aug 2020 09:18:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725924AbgHVHR7 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sat, 22 Aug 2020 03:17:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725864AbgHVHR6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 22 Aug 2020 03:17:58 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63EEEC061573
        for <linux-xfs@vger.kernel.org>; Sat, 22 Aug 2020 00:17:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=FjwWEqQ8ovTvtLB/9RcfMFL6Dc/armwR07VYX8N5yME=; b=ZivnqTSFL7j97WPUSwal0hoWJj
        N1JMVkzLon7qy9Sd7OT6JVJw4to2SPyrqee1ZnkH6sBfUXOCFfYBpjpELR348e/gTpXynkygxdsWY
        MuquwzWLFhifBiuGeLcPKVOwWbQJyMd77ruwEMccaK/r6OeUvfcNSlXpEIxkOaL1oRYPi9YBKLWyl
        b2UuGFzjzgaZTIw5Y6ZsZxEHn9YsOczbT7EGRrkf7Z+UB/BbqIzNXRNLDBNMuahynLnzuklj7Yq6q
        8V0E8K4e0EHiA9iXSB9TYf2Hd//O5M5g2NG8/966uTylsW0EfzSrY2l5MS50K0PcyjKmr9Sn5or4v
        zk4JVVyg==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k9Nml-0000v9-7U; Sat, 22 Aug 2020 07:17:55 +0000
Date:   Sat, 22 Aug 2020 08:17:55 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Amir Goldstein <amir73il@gmail.com>, linux-xfs@vger.kernel.org,
        sandeen@sandeen.net
Subject: Re: [PATCH 06/11] xfs: refactor inode timestamp coding
Message-ID: <20200822071755.GF1629@infradead.org>
References: <159797588727.965217.7260803484540460144.stgit@magnolia>
 <159797592873.965217.7436192080471557112.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159797592873.965217.7436192080471557112.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 20, 2020 at 07:12:08PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Refactor inode timestamp encoding and decoding into helper functions so
> that we can add extra behaviors in subsequent patches.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Amir Goldstein <amir73il@gmail.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
