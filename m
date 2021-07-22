Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEBDC3D1E52
	for <lists+linux-xfs@lfdr.de>; Thu, 22 Jul 2021 08:36:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230136AbhGVFzj (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 22 Jul 2021 01:55:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229931AbhGVFzj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Jul 2021 01:55:39 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7D86C061575;
        Wed, 21 Jul 2021 23:36:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=ac7vOUC6TvYtdMuOihfA0ujK9h
        WjngpkShW7u+68KJ783edaZ/bFvlUXd1O/o0enGWYLym2v8IKcSLn3JT8lxHnF/WtkSzYlIMDGizn
        C4x5rkF0crXvB/HAmpgAjseddVLX3gMLAy70tZp3Jb9eXGCjOHI8JNuZBAUGJuPzPENNYZ0oNjjTa
        eyRlCVD6oxmp1VBoTfffYCmrISQFKbAM4R62tynzat1GRjpeP6Zc50gpSpn6eRAVNbuoWkiHihl0J
        6xJIYsVRss+cTdIyhccoPQ2ke4dd3gpB5EunZ3EWqFoPlnnKic3yFjiRU7q10e5EB6BUQl+zSNKsh
        LwGK+9Cw==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m6SIv-009xad-3R; Thu, 22 Jul 2021 06:35:44 +0000
Date:   Thu, 22 Jul 2021 07:35:33 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 1/1] new: allow users to specify a new test id
Message-ID: <YPkRtWqPh2lua7DF@infradead.org>
References: <162674329655.2650678.3298345419686024312.stgit@magnolia>
 <162674330211.2650678.4087092414669814557.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162674330211.2650678.4087092414669814557.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
