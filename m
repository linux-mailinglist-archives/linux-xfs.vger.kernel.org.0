Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B71AC3AA5B3
	for <lists+linux-xfs@lfdr.de>; Wed, 16 Jun 2021 22:54:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233761AbhFPU4m (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 16 Jun 2021 16:56:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:38652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233698AbhFPU4m (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 16 Jun 2021 16:56:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7C5F4611BE;
        Wed, 16 Jun 2021 20:54:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623876875;
        bh=fjDbPH439GUQsnc14M1GUX3yI5JLER3vmJnE/oyiQjo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FWma+x+5P7zsbWDEFFyKopBK2Ux3gEZgxaav5SJzzoqM2wDGDQSjtAsLmRQYWXdS/
         5wrzsePpTJkN9UzzGPQmi07OHaHkdOks36ddfWRzfgkjuhUpqaSIl/Yu/Sm68sN5Av
         zhciXfWglHblD1fQO2Yo857k1M+3snG4Je5H5R+pWhpXcyyPjfzVPJ95oewBDjmWKe
         PwhvKUV//llhrNP4H+rDsCGpoa592lUBt00MSSWee8HYapfWtMO4SFhRL+xD0P4+c8
         GqZBhy48a3KyTLYe3x9dkU6ucQI3IJwiZiVjDRt3AZmm0HNuJgdN0wbMJ0NcYbZMD9
         JSMK+aqQXGx/w==
Date:   Wed, 16 Jun 2021 13:54:34 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com,
        Allison Henderson <allison.henderson@oracle.com>,
        Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        amir73il@gmail.com
Subject: Re: [PATCH 08/13] fstests: convert nextid to use automatic group
 generation
Message-ID: <YMplCulNbH+q0bg7@sol.localdomain>
References: <162370433910.3800603.9623820748404628250.stgit@locust>
 <162370438326.3800603.17823705689396942708.stgit@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162370438326.3800603.17823705689396942708.stgit@locust>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 14, 2021 at 01:59:43PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Convert the nextid script to use the automatic group file generation to
> figure out the next available test id.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
> Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

Reviewed-by: Eric Biggers <ebiggers@google.com>
