Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 921D82FD9DF
	for <lists+linux-xfs@lfdr.de>; Wed, 20 Jan 2021 20:43:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392582AbhATTkh (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 20 Jan 2021 14:40:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:34218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392643AbhATTkT (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 20 Jan 2021 14:40:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1B23523433;
        Wed, 20 Jan 2021 19:39:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611171559;
        bh=rQQ6Bs0I7wpHZBIl0s9elZUwwbQQaRIZcMnWCQEJ5LU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Sl8BSz/yEvNf3HYiPM+EEhrpiEjJVIixeybVgGJH7JYwLKZ2GIsVu/tsUrH3VShaN
         93HVfdKI1jx9kAqOeYSFtleSY/WReuBDiMTYMJYq9urZaNEBKcOn8oXK8lMNkD1j7J
         36deAOc1vS6qv6mEJ0YPAYo1MR7xmwvCM83+pJ3ENLaA0uTxPw7grf1ci74TisswAX
         aXpnQHeWKXzP2iKktedv3787XGzFWIu6Ibj7hMZ8v+BE7/Qf9RtRhZzxMIKX3qwSPu
         UtuKY/7ISTu4sUnOtkCMuhxATFC5eroyfobWkjqbXrvPmKK9vIxkqVXD7V0Y8K7lpu
         QuG/08Sd11bnA==
Date:   Wed, 20 Jan 2021 11:39:18 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: two small setattr cleanups
Message-ID: <20210120193918.GO3134581@magnolia>
References: <20201210054821.2704734-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201210054821.2704734-1-hch@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Dec 10, 2020 at 06:48:19AM +0100, Christoph Hellwig wrote:
> Hi all,
> 
> this series contains two cleanups to the setattr patch.  I did
> those in preparation for supporting idmapped mounts in XFS, but
> I think they are useful on their own.

Apparently I never sent an official RVB on this before merging it...

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D
