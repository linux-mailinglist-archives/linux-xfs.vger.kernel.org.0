Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CD3D3AA5D5
	for <lists+linux-xfs@lfdr.de>; Wed, 16 Jun 2021 23:00:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233710AbhFPVCq (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 16 Jun 2021 17:02:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:40052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233678AbhFPVCq (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 16 Jun 2021 17:02:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A60B66109D;
        Wed, 16 Jun 2021 21:00:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623877239;
        bh=VALtrfKdhQIGmmz6Evta1SlvWpjktFxp7WZw9xOC3+s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UKxX/YZyxrlSE/34lshIr0dQy3NWgCKR9JL8AMG1cFzGQtexLZanO/XgmDCCzWiix
         ZUJvJ7Rj3+aVJTuouf73MuRLr8MUbdglukzyGynNTUxisM9ACiBluqCvgBIkBIIGUZ
         3VXYAX122fMqRXSk2Q9RC+YMQ1ixSBS2UYStiyrO9bHef/s6MK55dUSNShlxUNXaTZ
         JnoVNb7VXMyN1eX7jwpKARi6sJsxmg80h3iq+PkXcey3Q04quC5a/H2eXvZ2LxJhLq
         bIDLGEeHlF7WMh07At0CBo2YyyykUIBs/VsPAvjpUuBEvNkn621l0Fj0xBIpLKDAjc
         r0k3rtEncckhA==
Date:   Wed, 16 Jun 2021 14:00:38 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com,
        Allison Henderson <allison.henderson@oracle.com>,
        Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        amir73il@gmail.com
Subject: Re: [PATCH 13/13] misc: update documentation to reflect
 auto-generated group files
Message-ID: <YMpmdsFuRqwBfatu@sol.localdomain>
References: <162370433910.3800603.9623820748404628250.stgit@locust>
 <162370441083.3800603.11964136184573090396.stgit@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162370441083.3800603.11964136184573090396.stgit@locust>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 14, 2021 at 02:00:10PM -0700, Darrick J. Wong wrote:
> +     6. Test group membership: Each test can be associated with any number
> +	of groups for convenient selection of subsets of tests.  Test names
> +	can be any sequence of non-whitespace characters.

I think this should be "Test group names", not "Test names"?

- Eric
