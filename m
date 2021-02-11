Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2862319505
	for <lists+linux-xfs@lfdr.de>; Thu, 11 Feb 2021 22:19:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbhBKVTC (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 11 Feb 2021 16:19:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:33296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229642AbhBKVTB (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 11 Feb 2021 16:19:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AB9FB64DA5;
        Thu, 11 Feb 2021 21:18:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613078299;
        bh=oF8hcEhO+wbV3tmxGhwFNoND+JNQZKB40vT6/lAQNT4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NR6TqmRSfOAjt9PdsE3vEJUzLycLzAaOiY40TfvbRNFscoAPJFgjKiHpEhGRz/AMj
         /ToLg6oFgPqRaFgLFry/RMBvEs7qodqviPM4hy2/deBmT3pMmuAtLWwtHL3VhCd25H
         VDKOMiqr45bHT7gVbaw+jeBR/CKPYzaEuDQmxegXd1X+ircvuPaWrF7Pv48szAt3Xi
         KwU+jvPCOVJEPfPaXZbh6RG/qFJRw7JgBiwaU0Aj6Y/1k3Y3U/zZ+w8sBi0OiXi0NR
         RMjMdu04I0eguHkRUiag6cqm0L00ZsdSF7fIZ7fLkftsV91JDt3l83uFoBfzSzRdIj
         D8HaG8WgXcPuA==
Date:   Thu, 11 Feb 2021 13:18:18 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>, guaneryu@gmail.com,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 4/4] fsstress: get rid of attr_list
Message-ID: <20210211211818.GK7190@magnolia>
References: <160505547722.1389938.14377167906399924976.stgit@magnolia>
 <160505550232.1389938.14087037220733512558.stgit@magnolia>
 <20201114104753.GG11074@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201114104753.GG11074@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Nov 14, 2020 at 10:47:53AM +0000, Christoph Hellwig wrote:
> Instead of the loop to check if the attr existed can't we just check
> for the ENODATA return value from removexattr?

Yes.

> Also I think with this series we can drop the libattr dependency
> for xfstests, can't we?

I'll do that in a subsequent patch.

--D
