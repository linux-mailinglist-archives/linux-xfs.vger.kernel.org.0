Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA2911917ED
	for <lists+linux-xfs@lfdr.de>; Tue, 24 Mar 2020 18:44:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727223AbgCXRok (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 24 Mar 2020 13:44:40 -0400
Received: from mail-io1-f46.google.com ([209.85.166.46]:45062 "EHLO
        mail-io1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727273AbgCXRok (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Mar 2020 13:44:40 -0400
Received: by mail-io1-f46.google.com with SMTP id e20so18624576ios.12
        for <linux-xfs@vger.kernel.org>; Tue, 24 Mar 2020 10:44:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=V6JedzL6u61A7D0hhMvUxsEO4hYeFJt1Ckp3ppCb1d0=;
        b=bWmdgMQsgIbfDLCJHozH5GNK4iCLUIOuHVtKH1NPtkB4Yf8mhGk3qGQ3RLr7QSkUKr
         6HzqeOYZ7ryLERZjvYmNP9Bn7vLeIXdB1gJb+M8i1CPE/I8otJZVLXRXfpW4Whz9Faye
         ohCc97Zjb2PQRG5uiLzHRmghODvwOsC+wL6g0rpiYOlpp+Zu3CoDaDIi86eiI7slWekq
         cx7WTPdyT5b0ueLRHJdGfHvjiAOVkHpKdqSLGP9249VRFz+Wawc77VdgUWLgkob7ddYa
         ff/9g7jGf1z/ryyi1aemjKfTzO4SNP/Z6kThO7caBVaY1p3qacmsvwrRNn77mN/X3K5c
         +UhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=V6JedzL6u61A7D0hhMvUxsEO4hYeFJt1Ckp3ppCb1d0=;
        b=QjkPTPattBaTxj7Dr9FGx+cY3XxZ1kbt/G9ncknB/Cj9fMNa8IKNcy6lSt6wAx0nlV
         KxSE7O0yxpeTLlHsNtU43SutQgnkJOePlIVCkmIhMnh+i+gpDNk7MjtbjdTEM3v8SDsN
         CAEvp4qEE/DW4eLByyCSqvh1ATF7ntnOT/I+rR2E2rSWkbtzEk+8EPHnhuKKftZ5Ogxk
         h0Db761ZcJrMtNas1Sg6ltINLs5GrG7+fP0jG/QqJcG/HOm+1lejAZkpXXHL+5P4Vf7N
         monkvKDBBD2XJm8ttKF9ypCXmC7a7YuUDXZsQz6Egcxe+NHblmTCSpn5WCaFA9Fbx9ev
         RGCA==
X-Gm-Message-State: ANhLgQ3KYljBcRsVrrzKuITuxl9Nu+Ixn3V6cQ5mEiobpUnEO27QuGvB
        L9/ng30VLHeBnThmJWRl2w8GYkw9F/tSKl+rFQpfLJKc
X-Google-Smtp-Source: ADFU+vukT7vegJmhKa/so77cMoZxvjm22Ee84os6mIGjiY7TqKGTnuQpPU+s1UAQQ7xpXbiCfEatbOvVwkfP+GtqHYA=
X-Received: by 2002:a5d:8a10:: with SMTP id w16mr13438055iod.153.1585071879338;
 Tue, 24 Mar 2020 10:44:39 -0700 (PDT)
MIME-Version: 1.0
References: <CABS7VHBR1TqgdKEvN8pnRH8ZxZZUeEFm6pFfaygOzv0781QrRg@mail.gmail.com>
 <20200324183819.36aa5448@harpe.intellique.com>
In-Reply-To: <20200324183819.36aa5448@harpe.intellique.com>
From:   Pawan Prakash Sharma <pawanprakash101@gmail.com>
Date:   Tue, 24 Mar 2020 23:14:03 +0530
Message-ID: <CABS7VHB2FJdCz+F+3y86wawmBSuaVmfnC57edHVsoRugAK2Nsg@mail.gmail.com>
Subject: Re: xfs duplicate UUID
To:     Emmanuel Florac <eflorac@intellique.com>
Cc:     linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> Did you try to mount it with the "nouuid" option?

yes, that is working fine. I am able to mount it. But I am not sure
the side effect of doing that as there will not be any uuid generated
and xfsdump/xfsrestore might need that. Correct me if I am wrong.

Regards,
Pawan.

On Tue, Mar 24, 2020 at 11:08 PM Emmanuel Florac <eflorac@intellique.com> w=
rote:
>
> Le Tue, 24 Mar 2020 21:43:25 +0530
> Pawan Prakash Sharma <pawanprakash101@gmail.com> =C3=A9crivait:
>
> > Now, when I am creating a ZFS snapshot and ZFS clone and trying to
> > mount the clone filesystem, I am getting duplicate UUID error and I am
> > not able to moiunt it.
> >
>
> Did you try to mount it with the "nouuid" option?
>
> --
> ------------------------------------------------------------------------
> Emmanuel Florac     |   Direction technique
>                     |   Intellique
>                     |   <eflorac@intellique.com>
>                     |   +33 1 78 94 84 02
> ------------------------------------------------------------------------
