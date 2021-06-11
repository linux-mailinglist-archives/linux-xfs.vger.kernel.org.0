Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 794793A4B2D
	for <lists+linux-xfs@lfdr.de>; Sat, 12 Jun 2021 01:25:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229980AbhFKX06 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 11 Jun 2021 19:26:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:37522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229540AbhFKX06 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 11 Jun 2021 19:26:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7844E611B0;
        Fri, 11 Jun 2021 23:24:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623453899;
        bh=HvVZV9XqBsKUgOm5+FDgFFRqdmVYgSddel/s0soYIEk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=O+clDtJJAQ9oYmm5ixCOJpls/fG2RqnstNg1jm8n/d2buAxbqtQn5h0oswU1YTm78
         8z40lvy4z89I7HteYH8EPnhHb/psJJUgQG8AWliZlYrXYzaiJlV6ASUrErvF6kysQ6
         l8pMrNV3NX43/urCCnz5hYXU8pn3P/K74D/WIb6gvVYkprmyqjJqXNIV5DEwjQ/fof
         N4ycragFMEOIqQiewusfxykdkdb9pKV1xpeTYV2tCL+jX92wom4mobuhqWSmGoT4BD
         3JasZEjalgFHgW2hvFVYfzjqyDLWCllwkuaU1etcCyFXDFXC4oZg8w0Lp9cFUwPYYE
         6VxN/QNjzknQQ==
Date:   Fri, 11 Jun 2021 16:24:57 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me, amir73il@gmail.com
Subject: Re: [PATCH 11/13] fstests: remove group files
Message-ID: <YMPwyeb8wgqzEbeH@gmail.com>
References: <162317276202.653489.13006238543620278716.stgit@locust>
 <162317282225.653489.1537192803992898300.stgit@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162317282225.653489.1537192803992898300.stgit@locust>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 08, 2021 at 10:20:22AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Now that we autogenerate group files, get rid of them in the source
> tree.
> 

This breaks 'make install', since tests/*/Makefile still try to install "group"
instead of "group.list".  Changing them to use "group.list" instead fixed it.

- Eric
